/*
 * Mana Mobile
 * Copyright (C) 2010  Thorbjørn Lindeijer 
 *
 * This library is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation; either version 2.1 of the License, or (at your option)
 * any later version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License
 * for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this library; if not, see <http://www.gnu.org/licenses/>.
 */

#include "tilelayeritem.h"

#include "tiled/tile.h"
#include "tiled/tilelayer.h"
#include "tiled/map.h"
#include "tiled/maprenderer.h"

#include "mana/mapitem.h"
#include "mana/resource/imageresource.h"
#include "mana/resource/mapresource.h"
#include "mana/tilesnode.h"

using namespace Tiled;
using namespace Mana;

namespace {

/**
 * Returns the texture of a given tileset, or 0 if the image has not been
 * loaded yet.
 */
static inline QSGTexture *tilesetTexture(Tileset *tileset,
                                         const MapItem *mapItem,
                                         QQuickWindow *window)
{
    if (const ImageResource *image = mapItem->mapResource()->tilesetImage(tileset))
        if (image->isReady())
            return image->texture(window);
    return 0;
}

/**
 * This helper class exists mainly to avoid redoing calculations that only need
 * to be done once per tileset.
 */
struct TilesetHelper
{
    TilesetHelper(const MapItem *mapItem)
        : mMapItem(mapItem)
        , mWindow(mapItem->window())
        , mTileset(0)
        , mTexture(0)
        , mMargin(0)
        , mTileHSpace(0)
        , mTileVSpace(0)
        , mTilesPerRow(0)
    {
    }

    Tileset *tileset() const { return mTileset; }
    QSGTexture *texture() const { return mTexture; }

    void setTileset(Tileset *tileset)
    {
        mTileset = tileset;
        mTexture = tilesetTexture(tileset, mMapItem, mWindow);
        if (!mTexture)
            return;

        const int tileSpacing = tileset->tileSpacing();
        mMargin = tileset->margin();
        mTileHSpace = tileset->tileWidth() + tileSpacing;
        mTileVSpace = tileset->tileHeight() + tileSpacing;

        const QSize tilesetSize = mTexture->textureSize();
        const int availableWidth = tilesetSize.width() + tileSpacing - mMargin;
        mTilesPerRow = availableWidth / mTileHSpace;
    }

    void setTextureCoordinates(TileData &data, const Cell &cell) const
    {
        const int tileId = cell.tile->id();
        const int column = tileId % mTilesPerRow;
        const int row = tileId / mTilesPerRow;

        data.tx = column * mTileHSpace + mMargin;
        data.ty = row * mTileVSpace + mMargin;
    }

private:
    const MapItem *mMapItem;
    QQuickWindow *mWindow;
    Tileset *mTileset;
    QSGTexture *mTexture;
    int mMargin;
    int mTileHSpace;
    int mTileVSpace;
    int mTilesPerRow;
};

/**
 * Draws an orthogonal tile layer by adding nodes to the scene graph. As long
 * sequentially drawn tiles are using the same tileset, they will share a
 * single geometry node.
 */
static void drawTileLayer(QSGNode *parent,
                          const MapItem *mapItem,
                          const TileLayer *layer,
                          const QRect &rect)
{
    TilesetHelper helper(mapItem);

    const Map *map = mapItem->mapResource()->map();
    const int tileWidth = map->tileWidth();
    const int tileHeight = map->tileHeight();

    QVector<TileData> tileData;

    for (int y = rect.top(); y <= rect.bottom(); ++y) {
        for (int x = rect.left(); x <= rect.right(); ++x) {
            const Cell &cell = layer->cellAt(x, y);
            if (cell.isEmpty())
                continue;

            Tileset *tileset = cell.tile->tileset();

            if (tileset != helper.tileset()) {
                if (!tileData.isEmpty()) {
                    parent->appendChildNode(new TilesNode(helper.texture(),
                                                          tileData));
                    tileData.clear();
                }

                helper.setTileset(tileset);
            }

            if (!helper.texture())
                continue;

            const QSize size = cell.tile->size();
            const QPoint offset = tileset->tileOffset();

            TileData data;
            data.x = x * tileWidth + offset.x();
            data.y = (y + 1) * tileHeight - tileset->tileHeight() + offset.y();
            data.width = size.width();
            data.height = size.height();
            data.flippedHorizontally = cell.flippedHorizontally;
            data.flippedVertically = cell.flippedVertically;
            helper.setTextureCoordinates(data, cell);
            tileData.append(data);
        }
    }

    if (!tileData.isEmpty())
        parent->appendChildNode(new TilesNode(helper.texture(), tileData));
}

} // anonymous namespace


TileLayerItem::TileLayerItem(TileLayer *layer, MapRenderer *renderer,
                             MapItem *parent)
    : QQuickItem(parent)
    , mLayer(layer)
    , mRenderer(renderer)
    , mVisibleTiles(parent->visibleTileArea(layer))
{
    setFlag(ItemHasContents);

    connect(parent, SIGNAL(visibleAreaChanged()), SLOT(updateVisibleTiles()));

    syncWithTileLayer();
    setOpacity(mLayer->opacity());
}

void TileLayerItem::syncWithTileLayer()
{
    const QRectF boundingRect = mRenderer->boundingRect(mLayer->bounds());
    setPosition(boundingRect.topLeft());
    setSize(boundingRect.size());
}



QSGNode *TileLayerItem::updatePaintNode(QSGNode *node,
                                        QQuickItem::UpdatePaintNodeData *)
{
    const MapItem *mapItem = static_cast<MapItem*>(parentItem());

    if (!node) {
        node = new QSGNode;
        node->setFlag(QSGNode::OwnedByParent);
    }

    node->removeAllChildNodes();
    drawTileLayer(node, mapItem, mLayer, mVisibleTiles);

    return node;
}

void TileLayerItem::updateVisibleTiles()
{
    const MapItem *mapItem = static_cast<MapItem*>(parentItem());
    const QRect rect = mapItem->visibleTileArea(mLayer);

    if (mVisibleTiles != rect) {
        mVisibleTiles = rect;
        update();
    }
}


TileItem::TileItem(const Cell &cell, QPoint position, MapItem *parent)
    : QQuickItem(parent)
    , mCell(cell)
    , mPosition(position)
{
    setFlag(ItemHasContents);
    setZ(position.y() * parent->mapResource()->map()->tileHeight());
}

QSGNode *TileItem::updatePaintNode(QSGNode *node, QQuickItem::UpdatePaintNodeData *)
{
    if (!node) {
        const MapItem *mapItem = static_cast<MapItem*>(parent());

        TilesetHelper helper(mapItem);
        Tileset *tileset = mCell.tile->tileset();
        helper.setTileset(tileset);

        if (!helper.texture())
            return 0;

        const Map *map = mapItem->mapResource()->map();
        const int tileWidth = map->tileWidth();
        const int tileHeight = map->tileHeight();

        const QSize size = mCell.tile->size();
        const QPoint offset = tileset->tileOffset();

        QVector<TileData> data(1);
        data[0].x = mPosition.x() * tileWidth + offset.x();
        data[0].y = (mPosition.y() + 1) * tileHeight - tileset->tileHeight() + offset.y();
        data[0].width = size.width();
        data[0].height = size.height();
        helper.setTextureCoordinates(data[0], mCell);

        node = new TilesNode(helper.texture(), data);
    }

    return node;
}
