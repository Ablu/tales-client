/*
 * Mana QML plugin
 * Copyright (C) 2010  Thorbjørn Lindeijer
 * Copyright (C) 2013  Erik Schilling <ablu.erikschilling@googlemail.com>
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

#include "abilitylistmodel.h"
#include "accountclient.h"
#include "attributelistmodel.h"
#include "beinglistmodel.h"
#include "characterlistmodel.h"
#include "chatclient.h"
#include "droplistmodel.h"
#include "enetclient.h"
#include "gameclient.h"
#include "inventorylistmodel.h"
#include "mapitem.h"
#include "resourcelistmodel.h"
#include "resourcemanager.h"
#include "settings.h"
#include "shoplistmodel.h"
#include "spriteitem.h"
#include "spritelistmodel.h"
#include "questloglistmodel.h"

#include "resource/abilitydb.h"
#include "resource/attributedb.h"
#include "resource/hairdb.h"
#include "resource/itemdb.h"
#include "resource/mapresource.h"
#include "resource/monsterdb.h"
#include "resource/npcdb.h"
#include "resource/racedb.h"

#include <QQmlEngine>
#include <QQmlEngineExtensionPlugin>
#include <QQmlContext>

extern void qml_register_types_Mana();

class ManaPlugin : public QQmlEngineExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID QQmlEngineExtensionInterface_iid)

public:
    explicit ManaPlugin(QObject *parent = nullptr)
        : QQmlEngineExtensionPlugin(parent)
    {
        // ensure that this is not optimized away by the linker
        volatile auto registration = &qml_register_types_Mana;
        Q_UNUSED(registration);
    }

public:
    void initializeEngine(QQmlEngine *engine, const char *uri) override
    {
        QQmlEngineExtensionPlugin::initializeEngine(engine, uri);

        Mana::ResourceManager *resourceManager = new Mana::ResourceManager(engine);
        Mana::AbilityDB *abilityDB = new Mana::AbilityDB(engine);
        Mana::AttributeDB *attributeDB = new Mana::AttributeDB(engine);
        Mana::HairDB *hairDB = new Mana::HairDB(engine);
        Mana::ItemDB *itemDB = new Mana::ItemDB(engine);
        Mana::MonsterDB *monsterDB = new Mana::MonsterDB(engine);
        Mana::NpcDB *npcDB = new Mana::NpcDB(engine);
        Mana::RaceDB *raceDB = new Mana::RaceDB(engine);

        QQmlContext *context = engine->rootContext();
        context->setContextProperty("resourceManager", resourceManager);
        context->setContextProperty("abilityDB", abilityDB);
        context->setContextProperty("attributeDB", attributeDB);
        context->setContextProperty("hairDB", hairDB);
        context->setContextProperty("itemDB", itemDB);
        context->setContextProperty("monsterDB", monsterDB);
        context->setContextProperty("npcDB", npcDB);
        context->setContextProperty("raceDB", raceDB);

        int errorCode = enet_initialize();
        Q_ASSERT(errorCode == 0);
        atexit(enet_deinitialize);
    }
};

#include "manaplugin.moc"
