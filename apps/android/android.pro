TEMPLATE = app
TARGET = guitar-tools

QT += svg xml

include(../../src/guitar-tools.pri)

#INCLUDEPATH += $$PWD/soundtouch/include/
#LIBS += -L$$PWD/soundtouch/libs/$$ANDROID_TARGET_ARCH/ -lsoundtouch

RESOURCES += ui/ui.qrc
SOURCES += main.cpp

DEFINES += QT_DEPRECATED_WARNINGS

COMMON_DATA.path = /assets
COMMON_DATA.files = $$files(../../data/*)
INSTALLS += COMMON_DATA

#message("Include $$ANDROID_TARGET_ARCH/libsoundtouch.so")
#ANDROID_EXTRA_LIBS = $$PWD/soundtouch/libs/$$ANDROID_TARGET_ARCH/libsoundtouch.so

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

DISTFILES += \
    android/AndroidManifest.xml \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradlew \
    android/res/values/libs.xml \
    android/build.gradle \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew.bat

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android
