include(../../src/guitar-tools.pri)

TEMPLATE = app
TARGET = guitar-tools

INCLUDEPATH += /usr/include/soundtouch

LIBS += -lSoundTouch

RESOURCES += qml.qrc

SOURCES += main.cpp

QML_FILES += $$files(*.qml,true) \
             $$files(*.js,true)

#show all the files in QtCreator
OTHER_FILES += $${QML_FILES}

soundtouchLib.files += /usr/lib/$$system('dpkg-architecture -q DEB_HOST_MULTIARCH')/libSoundTouch.so.0.0.0
soundtouchLib.files += /usr/lib/$$system('dpkg-architecture -q DEB_HOST_MULTIARCH')/libSoundTouch.so.0
soundtouchLib.path = $${UBUNTU_CLICK_BINARY_PATH}/..

#load Ubuntu specific features
load(ubuntu-click)

# specify the manifest file, this file is required for click
# packaging and for the IDE to create runconfigurations
UBUNTU_MANIFEST_FILE=manifest.json.in

# specify translation domain, this must be equal with the
# app name in the manifest file
UBUNTU_TRANSLATION_DOMAIN="guitar-tools.t-mon"

# specify the source files that should be included into
# the translation file, from those files a translation
# template is created in po/template.pot, to create a
# translation copy the template to e.g. de.po and edit the sources
UBUNTU_TRANSLATION_SOURCES+= \
    $$files(*.qml,true) \
    $$files(*.js,true)  \
    $$files(*.cpp,true) \
    $$files(*.h,true) \
    $$files(*.desktop,true)

# specifies all translations files and makes sure they are
# compiled and installed into the right place in the click package
UBUNTU_PO_FILES+=$$files(po/*.po)

CONF_FILES += guitar-tools.apparmor \
              guitar-tools.png \
              guitar-tools.desktop

# install files
dataFolder.files = ../../data/
dataFolder.path = /guitar-tools

# specify where the config files are installed to
config_files.path = /guitar-tools
config_files.files += $${CONF_FILES}

# install the desktop file, a translated version is
# automatically created in the build directory
desktop_file.path = /guitar-tools
desktop_file.files = guitar-tools.desktop
desktop_file.CONFIG += no_check_exist

#show all the files in QtCreator
OTHER_FILES += $${CONF_FILES} \
               dataFolder

# Default rules for deployment.
target.path = $${UBUNTU_CLICK_BINARY_PATH}
INSTALLS += target desktop_file config_files dataFolder soundtouchLib

