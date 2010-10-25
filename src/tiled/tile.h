/*
 * tile.h
 * Copyright 2008-2009, Thorbjørn Lindeijer <thorbjorn@lindeijer.nl>
 * Copyright 2009, Edward Hutchins <eah1@yahoo.com>
 *
 * This file is part of Tiled.
 *
 * This program is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the Free
 * Software Foundation; either version 2 of the License, or (at your option)
 * any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
 * more details.
 *
 * You should have received a copy of the GNU General Public License along with
 * this program. If not, see <http://www.gnu.org/licenses/>.
 */

#ifndef TILE_H
#define TILE_H

#include "object.h"
#include "tileset.h"

#include <QPixmap>

namespace Tiled {

class TILEDSHARED_EXPORT Tile : public Object
{
public:
    Tile(const QPixmap &image, int id, Tileset *tileset):
        mId(id),
        mTileset(tileset),
        mImage(image)
    {}

    /**
     * Returns ID of this tile within its tileset.
     */
    int id() const { return mId; }

    /**
     * Returns the tileset that this tile is part of.
     */
    Tileset *tileset() const { return mTileset; }

    /**
     * Returns the image of this tile.
     */
    const QPixmap &image() const { return mImage; }

    /**
     * Sets the image of this tile.
     */
    void setImage(const QPixmap &image) { mImage = image; }

    // TODO: Methods below now returns tileset's tile width, which is a
    // temporary hack to work around problems with lazy-loaded tiles leading to
    // not updating the max tile size of the layer properly.

    /**
     * Returns the width of this tile.
     */
    int width() const { return mTileset->tileWidth(); }

    /**
     * Returns the height of this tile.
     */
    int height() const { return mTileset->tileHeight(); }

private:
    int mId;
    Tileset *mTileset;
    QPixmap mImage;
};

} // namespace Tiled

#endif // TILE_H
