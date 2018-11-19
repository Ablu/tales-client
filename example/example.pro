TEMPLATE=app

SOURCES += main.cpp
RESOURCES += main.qrc

TARGET = tales
QT += qml quick

CONFIG += c++11

INCLUDEPATH += $$PWD/../src/

LIBS += -L../src/ -lmana -lz

OTHER_FILES += \
    tizen/manifest.xml \
    android/AndroidManifest.xml \
    android/layout/splash.xml \
    android/res/values/strings.xml

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

DISTFILES += \
    android/AndroidManifest.xml
