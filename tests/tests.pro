TEMPLATE = app
TARGET = tests
CONFIG += warn_on qmltestcase
SOURCES += tests.cpp

OTHER_FILES += tst_Test.qml

IMPORTPATH += $$PWD/../lib/libmana/qml/
