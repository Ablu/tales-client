TEMPLATE = lib
CONFIG += qt plugin

linux*:DESTDIR = ../lib/libmana/qml/ManaTest/
else:DESTDIR = qml/Mana/
TARGET = manatest

QT += qml quick

INCLUDEPATH += src

SOURCES += \
    manatestplugin.cpp

HEADERS += \
    manatestplugin.h

folder_ManaTest.source = mana/qml/Mana
linux*:folder_ManaTest.target = ../../lib/libmana/qml
else:folder_ManaTest.target = qml
DEPLOYMENTFOLDERS = folder_ManaTest

# Please do not modify the following two lines. Required for deployment.
include(../../example/qtquick2applicationviewer/qtquick2applicationviewer.pri)
qtcAddDeployment()
