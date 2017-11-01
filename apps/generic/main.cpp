/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *                                                                         *
 *  Copyright (C) 2016-2017 Simon Stuerz <stuerz.simon@gmail.com>          *
 *                                                                         *
 *  This file is part of guitar tools.                                     *
 *                                                                         *
 *  Guitar tools is free software: you can redistribute it and/or modify   *
 *  it under the terms of the GNU General Public License as published by   *
 *  the Free Software Foundation, version 3 of the License.                *
 *                                                                         *
 *  Guitar tools is distributed in the hope that it will be useful,        *
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of         *
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the           *
 *  GNU General Public License for more details.                           *
 *                                                                         *
 *  You should have received a copy of the GNU General Public License      *
 *  along with guitar tools. If not, see <http://www.gnu.org/licenses/>.   *
 *                                                                         *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QIcon>
#include <QQuickView>
#include <QtGlobal>
#include <QCommandLineParser>
#include <QCommandLineOption>
#include <QtQml>
#include <QtQml/QQmlContext>

#include "core.h"
#include "composegrid.h"
#include "composescale.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);
    app.setApplicationName("guitar-tools");
    app.setOrganizationName("guitar-tools");
    app.setApplicationVersion("1.0.0");

    QCommandLineParser parser;
    parser.setApplicationDescription(QString("\nGuitar tools is a mobile application containing tools for guitar players like a tuner, a guitar player, "
                                             "a metronome and much more.\n\n"
                                             "Copyright %1 2016-2017 Simon Stürz <stuerz.simon@gmail.com>\n"
                                             "Released under the GNU GPLv3.").arg(QChar(0xA9)));
    parser.addPositionalArgument("dataPath", "The relative file path where the \"data\" folders can be found (optional).", "[dataPath]");
    parser.process(app);

    QDir dataDir;
    if (!parser.positionalArguments().isEmpty()) {
        dataDir = QDir::cleanPath(QCoreApplication::applicationDirPath() + "/" + parser.positionalArguments().first());
        if (!dataDir.exists()) {
            qWarning() << dataDir.path() << "does not exist.";
            exit(-1);
        }
    } else {
        dataDir = QDir(QCoreApplication::applicationDirPath() + "/../../../guitar-tools/data/");
    }

    qDebug() << "Usinf data dir" << dataDir.canonicalPath();

    Core::instance()->setDataDir(dataDir);

    qmlRegisterSingletonType<Core>("GuitarTools", 1, 0, "Core", Core::qmlInstance);
    qmlRegisterType<ComposeGrid>("GuitarTools", 1, 0, "ComposeGrid");
    qmlRegisterType<ComposeScale>("GuitarTools", 1, 0, "ComposeScale");

    qmlRegisterUncreatableType<Music>("GuitarTools", 1, 0, "Music", "Can't create this in QML. Get it from the Core instance.");

    qmlRegisterUncreatableType<Settings>("GuitarTools", 1, 0, "Settings", "Can't create this in QML. Get it from the Core instance.");
    qmlRegisterUncreatableType<AudioInput>("GuitarTools", 1, 0, "AudioInput", "Can't create this in QML. Get it from the Core instance.");
    qmlRegisterUncreatableType<GuitarTuner>("GuitarTools", 1, 0, "GuitarTuner", "Can't create this in QML. Get it from the Core instance.");
    qmlRegisterUncreatableType<SineWaveGenerator>("GuitarTools", 1, 0, "SineWaveGenerator", "Can't create this in QML. Get it from the Core instance.");
    qmlRegisterUncreatableType<Metronome>("GuitarTools", 1, 0, "Metronome", "Can't create this in QML. Get it from the Core instance.");
    qmlRegisterUncreatableType<Recorder>("GuitarTools", 1, 0, "Recorder", "Can't create this in QML. Get it from the Core instance.");
    qmlRegisterUncreatableType<Chord>("GuitarTools", 1, 0, "Chord", "Can't create this in QML. Get it from the Chords.");
    qmlRegisterUncreatableType<Chords>("GuitarTools", 1, 0, "Chords", "Can't create this in QML. Get it from the Core instance.");
    qmlRegisterUncreatableType<ChordsProxy>("GuitarTools", 1, 0, "ChordsProxy", "Can't create this in QML. Get it from the Core instance.");
    qmlRegisterUncreatableType<ChordPosition>("GuitarTools", 1, 0, "ChordPosition", "Can't create this in QML. Get it from the Chord.");
    qmlRegisterUncreatableType<ChordPositions>("GuitarTools", 1, 0, "ChordPositions", "Can't create this in QML. Get it from the Chord.");
    qmlRegisterUncreatableType<DrumLoopPlayer>("GuitarTools", 1, 0, "DrumLoopPlayer", "Can't create this in QML. Get it from the Chord.");
    qmlRegisterUncreatableType<NotePlayer>("GuitarTools", 1, 0, "NotePlayer", "Can't create this in QML. Get it from the Core.");
    qmlRegisterUncreatableType<ComposeTool>("GuitarTools", 1, 0, "ComposeTool", "Can't create this in QML. Get it from the Core instance.");
    qmlRegisterUncreatableType<ComposeNote>("GuitarTools", 1, 0, "ComposeNote", "Can't create this in QML. Get it from the ComposeNotes.");
    qmlRegisterUncreatableType<ComposeNotes>("GuitarTools", 1, 0, "ComposeNotes", "Can't create this in QML. Get it from the ComposeTool.");
    qmlRegisterUncreatableType<Scale>("GuitarTools", 1, 0, "Scale", "Can't create this in QML. Get it from the Scales.");
    qmlRegisterUncreatableType<Scales>("GuitarTools", 1, 0, "Scales", "Can't create this in QML. Get it from the Core.");
    qmlRegisterUncreatableType<ScalesProxy>("GuitarTools", 1, 0, "ScalesProxy", "Can't create this in QML. Get it from the Core.");
    qmlRegisterUncreatableType<FretPosition>("GuitarTools", 1, 0, "FretPosition", "Can't create this in QML. Get it from the Scale.");
    qmlRegisterUncreatableType<FretPositions>("GuitarTools", 1, 0, "FretPositions", "Can't create this in QML. Get it from the Scale.");


    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("dataDirectory", "file:" + dataDir.canonicalPath());
    engine.rootContext()->setContextProperty("version", app.applicationVersion());
    engine.load(QUrl(QLatin1String("qrc:/main.qml")));

    return app.exec();
}
