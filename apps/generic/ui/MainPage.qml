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

import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2

import GuitarTools 1.0
import "components"

Page {
    id: root
    title: qsTr("Guitar Tools")
    header: ToolBar {
        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 10


            Label {
                text: qsTr("Guitar Tools")
                elide: Label.ElideRight
                //horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                Layout.fillWidth: true
            }

            IconToolButton {
                iconSource: dataDirectory + "/icons/settings.svg"
                onClicked: pageStack.push(Qt.resolvedUrl("SettingsPage.qml"))
            }

            IconToolButton {
                iconSource: dataDirectory + "/icons/info.svg"
                onClicked: pageStack.push(Qt.resolvedUrl("AboutPage.qml"))
            }
        }
    }


    Flickable {
        id: mainFlickable
        anchors.fill: parent
        contentHeight: toolsColumn.height
        clip: true

        Column {
            id: toolsColumn
            anchors.left: parent.left
            anchors.right: parent.right

            MainMenuListItem {
                id: guitarTunerToolItem
                anchors.left: parent.left
                anchors.right: parent.right

                // TRANSLATORS: The name of the tuner tool
                title: qsTr("Guitar tuner")
                onClicked:  {
                    Core.activateGuitarTuner()
                    pageStack.push(Qt.resolvedUrl("GuitarTunerPage.qml"))
                }
            }

            MainMenuListItem {
                id: guitarToolItem
                anchors.left: parent.left
                anchors.right: parent.right

                // TRANSLATORS: The name of the tuner tool
                title: qsTr("Guitar")
                onClicked:  {
                    Core.activateGuitarPlayer()
                    pageStack.push(Qt.resolvedUrl("GuitarPlayerPage.qml"))
                }
            }
        }
    }


    //            MainMenuListItem {
    //                id: guitarTunerToolItem
    //                // TRANSLATORS: The name of the tuner tool
    //                title: qsTr("Guitar tuner")
    //                imageName: dataDirectory + "icons/guitar-tuner.svg"
    //                onClicked:  {
    //                    Core.activateGuitarTuner()
    //                    root.pageStack.addPageToNextColumn(root, Qt.resolvedUrl("GuitarTunerPage.qml"))
    //                }
    //            }

    //            MainMenuListItem {
    //                id: guitarToolItem
    //                // TRANSLATORS: The name of the guitar player tool
    //                title: qsTr("Guitar")
    //                onClicked:  {
    //                    Core.activateGuitarPlayer()
    //                    root.pageStack.addPageToNextColumn(root, Qt.resolvedUrl("GuitarPlayerPage.qml"))
    //                }
    //            }

    //            MainMenuListItem {
    //                id: metronomeToolItem
    //                // TRANSLATORS: The name of the metronome tool
    //                title: qsTr("Metronome")
    //                onClicked:  {
    //                    Core.activateMetronome()
    //                    root.pageStack.addPageToNextColumn(root, Qt.resolvedUrl("MetronomePage.qml"))
    //                }
    //            }

    //            MainMenuListItem {
    //                id: chordsToolItem
    //                // TRANSLATORS: The name of the chord tool
    //                title: qsTr("Chords")
    //                onClicked:  {
    //                    Core.activateChord()
    //                    root.pageStack.addPageToNextColumn(root, Qt.resolvedUrl("ChordPage.qml"))
    //                }
    //            }


    //            MainMenuListItem {
    //                id: scalesToolItem
    //                // TRANSLATORS: The name of the scales tool
    //                title: qsTr("Scales")
    //                onClicked:  {
    //                    Core.activateScales()
    //                    root.pageStack.addPageToNextColumn(root, Qt.resolvedUrl("ScalesPage.qml"))
    //                }
    //            }

    //            MainMenuListItem {
    //                id: recorderToolItem
    //                // TRANSLATORS: The name of the recorder tool
    //                title: qsTr("Recorder")
    //                onClicked:  {
    //                    Core.activateRecorder()
    //                    root.pageStack.addPageToNextColumn(root, Qt.resolvedUrl("RecorderPage.qml"))
    //                }
    //            }

    //            MainMenuListItem {
    //                id: drumLoopsToolItem
    //                // TRANSLATORS: The name of the drum loops tool
    //                title: qsTr("Drum loops")
    //                onClicked:  {
    //                    Core.activateDrumLoops()
    //                    root.pageStack.addPageToNextColumn(root, Qt.resolvedUrl("DrumLoopPage.qml"))
    //                }
    //            }

    //            MainMenuListItem {
    //                id: composeToolItem
    //                // TRANSLATORS: The name of the compose tool
    //                title: qsTr("Compose tool")
    //                onClicked:  {
    //                    root.pageStack.addPageToNextColumn(root, Qt.resolvedUrl("ComposePage.qml"))
    //                }
    //            }
    //        }
    //    }
}
