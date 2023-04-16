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

import QtQuick 2.4
import QtMultimedia 5.4
import QtQuick.Layouts 1.1
import Lomiri.Components 1.3
import Lomiri.Components.ListItems 1.3
import Qt.labs.folderlistmodel 1.0
import GuitarTools 1.0

Page {
    id: root
    header: PageHeader {
        id: pageHeader
        // TRANSLATORS: Title of the drum loops page
        title: i18n.tr("Drum loops")
        trailingActionBar.actions: [
            Action {
                iconName: "info"
                onTriggered: pageLayout.addPageToCurrentColumn(root, Qt.resolvedUrl("AboutPage.qml"))
            }
        ]
    }

    property string currentFileName: ""
    property real drumLoopsVolume: Core.settings.drumLoopsVolume

    Component.onDestruction: Core.drumLoopPlayer.stop()

    FolderListModel {
        id: folderModel
        folder: "file://" + dataDirectory + "sounds/drumloops/"
        nameFilters: [ "*.wav" ]
    }

    Connections {
        target: Qt.application
        onActiveChanged: {
            if (!Qt.application.active)
                Core.drumLoopPlayer.stop()
        }
    }

    Column {
        id: playerColumn
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: pageHeader.bottom

        Item {
            anchors.left: parent.left
            anchors.right: parent.right
            height: units.gu(6)
            Label {
                anchors.centerIn: parent
                color: theme.palette.normal.baseText
                font.bold: true
                font.pixelSize: units.gu(2)
                text: Core.drumLoopPlayer.bpm + " [bpm]"
            }
        }

        Item {
            anchors.left: parent.left
            anchors.right: parent.right
            height: units.gu(6)

            RowLayout {
                anchors.left: parent.left
                anchors.leftMargin: units.gu(2)
                anchors.right: parent.right
                anchors.rightMargin: units.gu(2)
                anchors.verticalCenter: parent.verticalCenter

                Icon {
                    Layout.minimumWidth: units.gu(3)
                    implicitHeight: units.gu(3)
                    implicitWidth: width
                    name: "remove"
                    MouseArea {
                        anchors.fill: parent
                        onClicked: bpmSlider.value = bpmSlider.minimumValue
                    }
                }

                Slider {
                    id: bpmSlider
                    Layout.fillWidth: true
                    value: Math.round(minimumValue + (maximumValue - minimumValue) / 2)
                    minimumValue: Core.drumLoopPlayer.minBpm
                    maximumValue: Core.drumLoopPlayer.maxBpm
                    onValueChanged: Core.drumLoopPlayer.bpm = Math.round(value)
                }

                Connections {
                    target: Core.drumLoopPlayer
                    onBpmChanged: bpmSlider.value = Math.round(Core.drumLoopPlayer.bpm)
                }

                Icon {
                    Layout.minimumWidth: units.gu(3)
                    implicitHeight: units.gu(3)
                    implicitWidth: width
                    name: "add"
                    MouseArea {
                        anchors.fill: parent
                        onClicked: bpmSlider.value = bpmSlider.maximumValue
                    }
                }
            }
        }

        Item {
            anchors.left: parent.left
            anchors.right: parent.right
            height: units.gu(6)

            RowLayout {
                anchors.left: parent.left
                anchors.leftMargin: units.gu(2)
                anchors.right: parent.right
                anchors.rightMargin: units.gu(2)
                anchors.verticalCenter: parent.verticalCenter

                Icon {
                    Layout.minimumWidth: units.gu(3)
                    implicitHeight: units.gu(3)
                    implicitWidth: width
                    name: "audio-speakers-muted-symbolic"
                    MouseArea {
                        anchors.fill: parent
                        onClicked: drumLoopsVolumeSlider.value = drumLoopsVolumeSlider.minimumValue
                    }
                }

                Slider {
                    id: drumLoopsVolumeSlider
                    Layout.fillWidth: true
                    minimumValue: 0
                    maximumValue: 100
                    value: drumLoopsVolume
                    onValueChanged: Core.settings.drumLoopsVolume = Math.round(value)
                }

                Icon {
                    Layout.minimumWidth: units.gu(3)
                    implicitHeight: units.gu(3)
                    implicitWidth: width
                    name: "audio-speakers-symbolic"
                    MouseArea {
                        anchors.fill: parent
                        onClicked: drumLoopsVolumeSlider.value = drumLoopsVolumeSlider.maximumValue
                    }
                }
            }
        }

        ThinDivider { }
    }

    ListView {
        id: loopListView
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: pageHeader.bottom
        anchors.topMargin: playerColumn.implicitHeight
        anchors.bottom: parent.bottom
        model: folderModel
        clip: true
        highlightFollowsCurrentItem: true
        ViewItems.expansionFlags: ViewItems.CollapseOnOutsidePress
        delegate: ListItem {
            ListItemLayout {
                id: itemLayout
                title.text: model.fileBaseName

                Rectangle {
                    SlotsLayout.position: SlotsLayout.Trailing;
                    width: units.gu(4)
                    height: width
                    color: "transparent"
                    radius: width / 2
                    border.color: Core.drumLoopPlayer.playing && currentFileName ===  model.fileName ? theme.palette.normal.baseText : "transparent"
                    border.width: units.gu(0.1)

                    Icon {
                        name: "media-playback-stop"
                        anchors.centerIn: parent
                        visible: Core.drumLoopPlayer.playing && currentFileName ===  model.fileName
                        width: units.gu(3)
                        height: width
                        implicitHeight: height
                        implicitWidth: width
                    }
                }
            }

            onClicked: {
                if (!Core.drumLoopPlayer.playing) {
                    currentFileName = model.fileName
                    Core.drumLoopPlayer.play(dataDirectory + "sounds/drumloops/" + model.fileName)
                } else {
                    Core.drumLoopPlayer.stop()
                }
            }
        }
    }
}



