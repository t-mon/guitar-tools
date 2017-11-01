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
import QtQuick.Layouts 1.1
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import Ubuntu.Components.ListItems 1.3
import Ubuntu.Components.Pickers 1.3
import GuitarTools 1.0

Page {
    id: root
    header: PageHeader {
        id: pageHeader
        // TRANSLATORS: Title of the song settings page of the composer tool
        title: i18n.tr("Song settings")
        flickable: settingsFlickable
    }

    Flickable {
        id: settingsFlickable
        anchors.fill: parent
        contentHeight: settingsColumn.height

        ColumnLayout {
            id: settingsColumn
            anchors.left: parent.left
            anchors.leftMargin: units.gu(2)
            anchors.right: parent.right
            anchors.rightMargin: units.gu(2)

            spacing: units.gu(1)

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: units.gu(10)

                Column {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter

                    Label {
                        // TRANSLATORS: The measures slider in the song settings. Indicates how many measures the song has.
                        text: i18n.tr("Measures") + ": " + Core.composeTool.measureCount + " (" + Core.composeTool.songDurationString + ")"
                    }

                    RowLayout {
                        anchors.left: parent.left
                        anchors.right: parent.right

                        Icon {
                            Layout.minimumWidth: units.gu(3)
                            implicitHeight: units.gu(3)
                            implicitWidth: width
                            name: "remove"
                            MouseArea {
                                anchors.fill: parent
                                onClicked: measureSlider.value = measureSlider.minimumValue
                            }
                        }

                        Slider {
                            id: measureSlider
                            Layout.fillWidth: true
                            minimumValue: 1
                            maximumValue: 60
                            onValueChanged: {
                                Core.composeTool.measureCount = Math.round(value)
                                Core.composeTool.save()
                            }
                            Component.onCompleted: measureSlider.value = Core.composeTool.measureCount
                        }

                        Icon {
                            Layout.minimumWidth: units.gu(3)
                            implicitHeight: units.gu(3)
                            implicitWidth: width
                            name: "add"
                            MouseArea {
                                anchors.fill: parent
                                onClicked: measureSlider.value = measureSlider.maximumValue
                            }
                        }
                    }
                }
            }

            ThinDivider { }

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: units.gu(10)

                Column {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter

                    Label {
                        // TRANSLATORS: The tracks slider description in the compose tool song settings (rows of the compose tool)
                        text: i18n.tr("Tracks") + " (" + Math.round(trackSlider.value) + ")"
                    }

                    RowLayout {
                        anchors.left: parent.left
                        anchors.right: parent.right

                        Icon {
                            Layout.minimumWidth: units.gu(3)
                            implicitHeight: units.gu(3)
                            implicitWidth: width
                            name: "remove"
                            MouseArea {
                                anchors.fill: parent
                                onClicked: trackSlider.value = trackSlider.minimumValue
                            }
                        }

                        Slider {
                            id: trackSlider
                            Layout.fillWidth: true
                            minimumValue: 1
                            maximumValue: 8
                            onValueChanged: {
                                Core.composeTool.trackCount = Math.round(value)
                                Core.composeTool.save()
                            }
                            Component.onCompleted: trackSlider.value = Core.composeTool.trackCount
                        }

                        Icon {
                            Layout.minimumWidth: units.gu(3)
                            implicitHeight: units.gu(3)
                            implicitWidth: width
                            name: "add"
                            MouseArea {
                                anchors.fill: parent
                                onClicked: trackSlider.value = trackSlider.maximumValue
                            }
                        }
                    }
                }
            }

            ThinDivider { }

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: units.gu(10)

                Column {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter

                    Label {
                        // TRANSLATORS: The bpm description in the compose tool song settings
                        text: i18n.tr("Beats per minute") + " (" + Math.round(bpmSlider.value) + ")"
                    }

                    RowLayout {
                        anchors.left: parent.left
                        anchors.right: parent.right

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
                            minimumValue: 40
                            maximumValue: 208
                            onValueChanged: {
                                Core.composeTool.bpm = Math.round(value)
                                Core.composeTool.save()
                            }

                            Component.onCompleted: bpmSlider.value = Core.composeTool.bpm
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
            }

            ThinDivider { }


            Label {
                // TRANSLATORS: The rythm description in the compose tool song settings (i.e. 4/4)
                text: i18n.tr("Rhythm") + " (" + tickPicker.model[tickPicker.selectedIndex] + "/4)"
            }

            Row {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter

                Picker {
                    id: tickPicker
                    width: parent.width
                    model: [2, 3, 4, 5, 6, 7, 8]
                    circular: false
                    delegate: PickerDelegate {
                        Label {
                            anchors.centerIn: parent
                            text: modelData
                        }
                    }
                    onSelectedIndexChanged: {
                        Core.composeTool.rythmTicks = tickPicker.model[selectedIndex]
                        Core.composeTool.save()
                    }
                    Component.onCompleted: selectedIndex = Core.composeTool.rythmTicks - 2
                }
            }

            ThinDivider { }

            Button {
                id: clearNotesButton
                // TRANSLATORS: Removes all notes in the compose tool
                text: i18n.tr("Clear all notes")
                Layout.fillWidth: true
                color: UbuntuColors.red
                onClicked: PopupUtils.open(clearNotesComponent)
            }
        }

        Component {
            id: clearNotesComponent
            Dialog {
                id: clearNotesDialog

                // TRANSLATORS: Title of the clear notes dialog
                title: i18n.tr("Clear all notes")

                // TRANSLATORS: Clear question for the delete song dialog
                text: i18n.tr("Are you sure you want to clear all notes in this song?")

                Button {
                    id: deleteButton
                    text: i18n.tr("Clear")
                    color: UbuntuColors.red
                    onClicked: {
                        PopupUtils.close(clearNotesDialog)
                        Core.composeTool.clearNotes()
                    }
                }

                ThinDivider { }

                Button {
                    text: i18n.tr("Cancel")
                    color: UbuntuColors.green
                    onClicked: PopupUtils.close(clearNotesDialog)
                }

            }
        }

    }
}
