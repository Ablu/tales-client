TEMPLATE = app

QT += qml quick
CONFIG += c++11 metatypes

SOURCES += main.cpp
RESOURCES += main.qrc

TARGET = tales

LIBS += -L../src/ -lmana -lz

PRE_TARGETDEPS += ../src/libmana.a

OTHER_FILES += \
    tizen/manifest.xml \
    android/AndroidManifest.xml \
    android/layout/splash.xml \
    android/res/values/strings.xml

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

DISTFILES += \
    android/AndroidManifest.xml
