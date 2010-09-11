# Check the Qt version. If QT_VERSION is not set, it is probably Qt 3.
isEmpty(QT_VERSION) {
    error("QT_VERSION not defined. Mana Mobile does not work with Qt 3.")
}
contains(QT_VERSION, ^4\\.[0-5]\\..*) {
    message("Cannot build Mana Mobile with Qt version $$QT_VERSION")
    error("Use at least Qt 4.6")
}

TEMPLATE = subdirs
SUBDIRS = src
