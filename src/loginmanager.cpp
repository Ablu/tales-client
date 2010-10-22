/*
 *  Mana Mobile
 *  Copyright (C) 2010  Thorbjørn Lindeijer
 *
 *  This file is part of Mana Mobile.
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#include "loginmanager.h"

#include "characterlistmodel.h"
#include "resourcemanager.h"
#include "root.h"
#include "safeassert.h"

#include <mana/accounthandlerinterface.h>
#include <mana/protocol.h>

#include <QTimerEvent>
#include <QDebug>

// Struggling with naming conflicts between interface methods and signals
class AccountHandler : public Mana::AccountHandlerInterface
{
public:
    AccountHandler(LoginManager *loginManager)
        : lm(loginManager)
    {}

    void connected() { emit lm->connected(); emit lm->isConnectedChanged(); }
    void disconnected() { emit lm->disconnected(); emit lm->isConnectedChanged(); }

    void loginSucceeded() {
        // Communicate the data url to the resource manager
        const QString dataUrl = QString::fromStdString(lm->mClient->dataUrl());
        Root::instance()->resourceManager()->setDataUrl(dataUrl);

        emit lm->loginSucceeded();
    }

    void loginFailed(int error) { lm->onLoginFailed(error); }

    void characterInfoReceived(const Mana::CharacterInfo &info)
    {
        lm->mCharacters.append(info);
        lm->mCharacterListModel->setCharacters(lm->mCharacters);
        emit lm->charactersChanged();
    }

    void chooseCharacterSucceeded()
    { lm->onChooseCharacterSucceeded(); }

    void chooseCharacterFailed(int error)
    { lm->onChooseCharacterFailed(error); }

private:
    LoginManager *lm;
};


LoginManager::LoginManager(Mana::ManaClient *client, QObject *parent)
    : QObject(parent)
    , mClient(client)
    , mAccountHandler(new AccountHandler(this))
    , mNetworkTrafficTimer(0)
    , mCharacterListModel(new CharacterListModel(this))
{
    mClient->setAccountHandler(mAccountHandler);
}

LoginManager::~LoginManager()
{
    delete mAccountHandler;
}

void LoginManager::connectToLoginServer(const QString &host,
                                        unsigned short port)
{
    qDebug() << Q_FUNC_INFO << host << port;
    mClient->connectToAccountServer(Mana::ServerAddress(host.toStdString(),
                                                        port));

    if (!mNetworkTrafficTimer)
        mNetworkTrafficTimer = startTimer(100);
}

void LoginManager::disconnectFromLoginServer()
{
    mClient->disconnectFromAccountServer();
}

bool LoginManager::isConnected() const
{
    return mClient->isConnectedToAccountServer();
}

void LoginManager::login(const QString &username, const QString &password)
{
    qDebug() << Q_FUNC_INFO << username;
    mClient->login(username.toStdString(), password.toStdString());
}

void LoginManager::chooseCharacter(int index)
{
    SAFE_ASSERT(index > 0 || index < mCharacters.size(), return);

    qDebug() << Q_FUNC_INFO << index;
    mClient->chooseCharacter(mCharacters.at(index));
}

void LoginManager::timerEvent(QTimerEvent *event)
{
    if (event->timerId() == mNetworkTrafficTimer)
        mClient->handleNetworkTraffic();
}

void LoginManager::onLoginFailed(int error)
{
    switch (error) {
    case Mana::ERRMSG_FAILURE:
    default:
        mError = tr("Unknown error");
        break;
    case Mana::ERRMSG_INVALID_ARGUMENT:
        mError = tr("Wrong user name or password");
        break;
    case Mana::LOGIN_INVALID_TIME:
        mError = tr("Tried to login too fast");
        break;
    case Mana::LOGIN_INVALID_VERSION:
        mError = tr("Client version too old");
        break;
    case Mana::LOGIN_BANNED:
        mError = tr("Account is banned");
        break;
    }

    qDebug() << Q_FUNC_INFO << error << mError;

    emit errorChanged();
    emit loginFailed();
}

void LoginManager::onChooseCharacterSucceeded()
{
    emit chooseCharacterSucceeded();
    mClient->connectToGameAndChatServers();
}

void LoginManager::onChooseCharacterFailed(int error)
{
    switch (error) {
    default:
        mError = tr("Unknown error");
        break;
    case Mana::ERRMSG_NO_LOGIN:
        mError = tr("You don't seem to be logged in, please try again");
        break;
    case Mana::ERRMSG_INVALID_ARGUMENT:
        mError = tr("No such character");
        break;
    case Mana::ERRMSG_FAILURE:
        mError = tr("No game server found for the map the character is on");
        break;
    }

    qDebug() << Q_FUNC_INFO << error << mError;

    emit errorChanged();
    emit chooseCharacterFailed();
}
