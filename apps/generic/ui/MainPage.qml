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

            IconToolButton {
                iconSource: dataDirectory + "/icons/navigation-menu.svg"
                onClicked: drawer.open()
            }

            Label {
                text: qsTr("Guitar Tools")
                font.family: "Roboto"
                elide: Label.ElideRight
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


            ItemDelegate {
                width: parent.width
                // TRANSLATORS: The name of the tuner tool
                text: qsTr("Guitar tuner")

                onClicked:  {
                    Core.activateGuitarTuner()
                    pageStack.push(Qt.resolvedUrl("GuitarTunerPage.qml"))
                }
            }

            ItemDelegate {
                width: parent.width
                // TRANSLATORS: The name of the guitar tool
                text: qsTr("Guitar")
                onClicked:  {
                    Core.activateGuitarPlayer()
                    pageStack.push(Qt.resolvedUrl("GuitarPlayerPage.qml"))
                }
            }

            ItemDelegate {
                width: parent.width
                // TRANSLATORS: The name of the metronome tool
                text: qsTr("Metronome")
                onClicked:  {
                    Core.activateMetronome()
                    pageStack.push(Qt.resolvedUrl("MetronomePage.qml"))
                }
            }

            ItemDelegate {
                width: parent.width
                // TRANSLATORS: The name of the chords tool
                text: qsTr("Chords")
                onClicked:  {
                    Core.activateChord()
                    pageStack.push(Qt.resolvedUrl("ChordPage.qml"))
                }
            }

            ItemDelegate {
                width: parent.width
                // TRANSLATORS: The name of the scales tool
                text: qsTr("Scales")
                onClicked:  {
                    Core.activateScales()
                    pageStack.push(Qt.resolvedUrl("ScalesPage.qml"))
                }
            }

            ItemDelegate {
                width: parent.width
                // TRANSLATORS: The name of the recorder tool
                text: qsTr("Recorder")
                onClicked:  {
                    Core.activateRecorder()
                    pageStack.push(Qt.resolvedUrl("RecorderPage.qml"))
                }
            }

            ItemDelegate {
                width: parent.width
                // TRANSLATORS: The name of the compose tool tool
                text: qsTr("Compose tool")
                onClicked:  {
                    pageStack.push(Qt.resolvedUrl("ComposePage.qml"))
                }
            }
        }
    }



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
