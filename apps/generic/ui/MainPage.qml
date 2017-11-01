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
    header: Item {
        height: 40
        width: parent.width

        Label {
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 10
            text: qsTr("Guitar Tools")
        }
    }


    //    header: PageHeader {
    //        id: pageHeader
    //        title: "Guitar Tools"
    //        flickable: mainFlickable
    //        trailingActionBar.actions: [
    //            Action {
    //                iconName: "settings"
    //                onTriggered: pageLayout.addPageToNextColumn(root, Qt.resolvedUrl("SettingsPage.qml"))
    //            },
    //            Action {
    //                iconName: "info"
    //                onTriggered: pageLayout.addPageToNextColumn(root, Qt.resolvedUrl("AboutPage.qml"))
    //            }
    //        ]
    //    }

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
                imageName: "file://" + dataDirectory + "icons/guitar-tuner.svg"
                onClicked:  {
                    console.log("Guitartuner pressed")
                    Core.activateGuitarTuner()
                    pageStack.push(Qt.resolvedUrl("GuitarTunerPage.qml"))
                }
            }
        }
    }


    //            MainMenuListItem {
    //                id: guitarTunerToolItem
    //                // TRANSLATORS: The name of the tuner tool
    //                title: i18n.tr("Guitar tuner")
    //                imageName: "file://" + dataDirectory + "icons/guitar-tuner.svg"
    //                onClicked:  {
    //                    Core.activateGuitarTuner()
    //                    root.pageStack.addPageToNextColumn(root, Qt.resolvedUrl("GuitarTunerPage.qml"))
    //                }
    //            }

    //            MainMenuListItem {
    //                id: guitarToolItem
    //                // TRANSLATORS: The name of the guitar player tool
    //                title: i18n.tr("Guitar")
    //                onClicked:  {
    //                    Core.activateGuitarPlayer()
    //                    root.pageStack.addPageToNextColumn(root, Qt.resolvedUrl("GuitarPlayerPage.qml"))
    //                }
    //            }

    //            MainMenuListItem {
    //                id: metronomeToolItem
    //                // TRANSLATORS: The name of the metronome tool
    //                title: i18n.tr("Metronome")
    //                onClicked:  {
    //                    Core.activateMetronome()
    //                    root.pageStack.addPageToNextColumn(root, Qt.resolvedUrl("MetronomePage.qml"))
    //                }
    //            }

    //            MainMenuListItem {
    //                id: chordsToolItem
    //                // TRANSLATORS: The name of the chord tool
    //                title: i18n.tr("Chords")
    //                onClicked:  {
    //                    Core.activateChord()
    //                    root.pageStack.addPageToNextColumn(root, Qt.resolvedUrl("ChordPage.qml"))
    //                }
    //            }


    //            MainMenuListItem {
    //                id: scalesToolItem
    //                // TRANSLATORS: The name of the scales tool
    //                title: i18n.tr("Scales")
    //                onClicked:  {
    //                    Core.activateScales()
    //                    root.pageStack.addPageToNextColumn(root, Qt.resolvedUrl("ScalesPage.qml"))
    //                }
    //            }

    //            MainMenuListItem {
    //                id: recorderToolItem
    //                // TRANSLATORS: The name of the recorder tool
    //                title: i18n.tr("Recorder")
    //                onClicked:  {
    //                    Core.activateRecorder()
    //                    root.pageStack.addPageToNextColumn(root, Qt.resolvedUrl("RecorderPage.qml"))
    //                }
    //            }

    //            MainMenuListItem {
    //                id: drumLoopsToolItem
    //                // TRANSLATORS: The name of the drum loops tool
    //                title: i18n.tr("Drum loops")
    //                onClicked:  {
    //                    Core.activateDrumLoops()
    //                    root.pageStack.addPageToNextColumn(root, Qt.resolvedUrl("DrumLoopPage.qml"))
    //                }
    //            }

    //            MainMenuListItem {
    //                id: composeToolItem
    //                // TRANSLATORS: The name of the compose tool
    //                title: i18n.tr("Compose tool")
    //                onClicked:  {
    //                    root.pageStack.addPageToNextColumn(root, Qt.resolvedUrl("ComposePage.qml"))
    //                }
    //            }
    //        }
    //    }
}
