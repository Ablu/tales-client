/*
 * manalib
 * Copyright 2010, Thorbjørn Lindeijer <thorbjorn@lindeijer.nl>
 *
 * This file is part of manalib.
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

#ifndef GAMECLIENT_H
#define GAMECLIENT_H

#include "enetclient.h"

namespace Mana {

class GameHandlerInterface;
class ManaClient;

namespace Internal {

/**
 * The game client allows interacting with the game server.
 */
class GameClient : public ENetClient
{
public:
    GameClient(ManaClient *manaClient);

    void setGameHandler(GameHandlerInterface *handler)
    { mGameHandler = handler; }

protected:
    void connected();
    void disconnected();
    void messageReceived(MessageIn &message);

private:
    GameHandlerInterface *mGameHandler;
    ManaClient *mManaClient;
};

} // namespace Internal
} // namespace Mana

#endif // GAMECLIENT_H
