TARGET = guitar-tools

CONFIG += soundtouch

include(../../src/guitar-tools.pri)

INCLUDEPATH += /usr/include/soundtouch
LIBS += -lSoundTouch

# Show qml file in QtCreator
QML_FILES = ui/*.qml

# Install data
data.files = ../../data
data.path = /usr/share/guitar-tools

RESOURCES += ui/ui.qrc
SOURCES += main.cpp

target.path = /usr/bin/
INSTALLS += target data
