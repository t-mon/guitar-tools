QT += qml quick multimedia

CONFIG += c++11

INCLUDEPATH += $$PWD

HEADERS += \
    $$PWD/guitartuner.h \
    $$PWD/libfft.h \
    $$PWD/core.h \
    $$PWD/metronome.h \
    $$PWD/analyzer.h \
    $$PWD/settings.h \
    $$PWD/audioinput.h \
    $$PWD/chord.h \
    $$PWD/chords.h \
    $$PWD/music.h \
    $$PWD/chordposition.h \
    $$PWD/chordpositions.h \
    $$PWD/chordsproxy.h \
    $$PWD/recorder.h \
    $$PWD/volumeanalyzer.h \
    $$PWD/sinewavegenerator.h \
    $$PWD/drumloopplayer.h \
    $$PWD/wavfile.h \
    $$PWD/scale.h \
    $$PWD/scales.h \
    $$PWD/fretposition.h \
    $$PWD/fretpositions.h \
    $$PWD/scalesproxy.h \
    $$PWD/noteplayer.h \
    $$PWD/composetool.h \
    $$PWD/composegrid.h \
    $$PWD/composescale.h \
    $$PWD/composenote.h \
    $$PWD/composenotes.h \

SOURCES += \
    $$PWD/guitartuner.cpp \
    $$PWD/libfft.cpp \
    $$PWD/core.cpp \
    $$PWD/metronome.cpp \
    $$PWD/analyzer.cpp \
    $$PWD/settings.cpp \
    $$PWD/audioinput.cpp \
    $$PWD/chord.cpp \
    $$PWD/chords.cpp \
    $$PWD/chordposition.cpp \
    $$PWD/chordpositions.cpp \
    $$PWD/chordsproxy.cpp \
    $$PWD/recorder.cpp \
    $$PWD/volumeanalyzer.cpp \
    $$PWD/sinewavegenerator.cpp \
    $$PWD/drumloopplayer.cpp \
    $$PWD/wavfile.cpp \
    $$PWD/scale.cpp \
    $$PWD/scales.cpp \
    $$PWD/fretposition.cpp \
    $$PWD/fretpositions.cpp \
    $$PWD/scalesproxy.cpp \
    $$PWD/noteplayer.cpp \
    $$PWD/composetool.cpp \
    $$PWD/composegrid.cpp \
    $$PWD/composescale.cpp \
    $$PWD/composenote.cpp \
    $$PWD/composenotes.cpp \


