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
import QtGraphicalEffects 1.0
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import Ubuntu.Components.Pickers 1.3
import Ubuntu.Components.ListItems 1.3
import GuitarTools 1.0

Page {
    id: root
    header: PageHeader {
        id: pageHeader
        // TRANSLATORS: Title of the settings page
        title: i18n.tr("Settings")
        flickable: settingsFlickable
    }

    property bool debug: Core.settings.debugEnabled
    property bool disableScreensaver: Core.settings.disableScreensaver
    property bool darkThemeEnabled: Core.settings.darkThemeEnabled
    property bool markNotAssociatedStrings: Core.settings.markNotAssociatedStrings
    property bool disableNotAssociatedStrings: Core.settings.disableNotAssociatedStrings
    property real metronomeVolume: Core.settings.metronomeVolume
    property real guitarPlayerVolume: Core.settings.guitarPlayerVolume
    property real drumLoopsVolume: Core.settings.drumLoopsVolume
    property real microphoneVolume: Core.settings.microphoneVolume
    property real chordPlayerDelay: Core.settings.chordPlayerDelay

    property color color1: Core.settings.color1
    property color color2: Core.settings.color2
    property color color3: Core.settings.color3

    Component.onCompleted: Core.activateSettings()

    Flickable {
        id: settingsFlickable
        anchors.fill: parent
        contentHeight: paramColumn.height

        ColumnLayout {
            id: paramColumn
            anchors.left: parent.left
            anchors.leftMargin: units.gu(2)
            anchors.right: parent.right
            anchors.rightMargin: units.gu(2)

            spacing: units.gu(1)

            ThinDivider { }

            Label {
                Layout.alignment: Qt.AlignHCenter
                font.bold: true
                fontSize: "large"
                // TRANSLATORS: In the settings page the metronome volume.
                text: i18n.tr("General settings")
            }

            ThinDivider { }

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: units.gu(3)

                Label {
                    anchors.left: parent.left
                    anchors.verticalCenter: debugCheckbox.verticalCenter
                    // TRANSLATORS: In the settings page the Debug checkbox description.
                    text: i18n.tr("Show details")
                }

                Switch {
                    id: debugCheckbox
                    anchors.right: parent.right
                    onCheckedChanged: {
                        Core.settings.debugEnabled = debugCheckbox.checked
                    }

                    Component.onCompleted: checked = debug
                }
            }

            ThinDivider { }

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: units.gu(3)

                Label {
                    anchors.left: parent.left
                    anchors.verticalCenter: screensaverCheckbox.verticalCenter
                    // TRANSLATORS: In the settings page the screen saver checkbox description.
                    text: i18n.tr("Disable screen saver")
                }

                Switch {
                    id: screensaverCheckbox
                    anchors.right: parent.right
                    onCheckedChanged: {
                        Core.settings.disableScreensaver = screensaverCheckbox.checked
                    }
                    Component.onCompleted: checked = disableScreensaver
                }
            }

            ThinDivider { }

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: units.gu(3)

                Label {
                    anchors.left: parent.left
                    anchors.verticalCenter: darkThemeCheckbox.verticalCenter
                    // TRANSLATORS: In the settings page the dark theme checkbox description.
                    text: i18n.tr("Dark theme")
                }

                Switch {
                    id: darkThemeCheckbox
                    anchors.right: parent.right
                    onCheckedChanged: {
                        Core.settings.darkThemeEnabled = darkThemeCheckbox.checked
                    }
                    Component.onCompleted: checked = darkThemeEnabled
                }
            }

            ThinDivider { }

            Label {
                // TRANSLATORS: In the settings page the chord player delay.
                text: i18n.tr("Chord player delay") + " [ " + Math.round(chordPlayerSlider.value) + "ms ]"
            }

            RowLayout {
                Layout.fillWidth: true

                Icon {
                    Layout.minimumWidth: units.gu(3)
                    implicitHeight: units.gu(3)
                    implicitWidth: width
                    name: "remove"
                    MouseArea {
                        anchors.fill: parent
                        onClicked: chordPlayerSlider.value = chordPlayerSlider.minimumValue
                    }
                }

                Slider {
                    id: chordPlayerSlider
                    Layout.fillWidth: true
                    minimumValue: 0
                    maximumValue: 1000
                    onValueChanged: Core.settings.chordPlayerDelay = Math.round(value)
                    Component.onCompleted: chordPlayerSlider.value = chordPlayerDelay

                }

                Icon {
                    Layout.minimumWidth: units.gu(3)
                    implicitHeight: units.gu(3)
                    implicitWidth: width
                    name: "add"
                    MouseArea {
                        anchors.fill: parent
                        onClicked: chordPlayerSlider.value = chordPlayerSlider.maximumValue
                    }
                }
            }


            ThinDivider { }

            Label {
                Layout.alignment: Qt.AlignHCenter
                font.bold: true
                fontSize: "large"
                // TRANSLATORS: In the settings page the metronome volume.
                text: i18n.tr("Guitar tuner")
            }

            ThinDivider { }

            OptionSelector {
                id: pitchStandardSelector
                model: ["434 Hz", "440 Hz"]
                Layout.fillWidth: true

                // TRANSLATORS: In the settings page the pitch standard selection
                text: i18n.tr("Pitch standard")

                onSelectedIndexChanged: {
                    if (selectedIndex === 0)
                        Core.settings.pitchStandard = 434

                    if (selectedIndex === 1)
                        Core.settings.pitchStandard = 440
                }

                Component.onCompleted: {
                    if (Core.settings.pitchStandard === 434)
                        selectedIndex = 0

                    if (Core.settings.pitchStandard === 440)
                        selectedIndex = 1
                }
            }

            ThinDivider { }

            Label {
                Layout.alignment: Qt.AlignHCenter
                font.bold: true
                fontSize: "large"
                text: i18n.tr("Guitar")
            }

            ThinDivider { }

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: units.gu(3)

                Label {
                    anchors.left: parent.left
                    anchors.verticalCenter: markNotAssociatedStringsCheckbox.verticalCenter
                    // TRANSLATORS: In the settings page. Section guitar: if true, the not associated chord string will be marked red.
                    text: i18n.tr("Mark not associated chord strings")
                }

                Switch {
                    id: markNotAssociatedStringsCheckbox
                    anchors.right: parent.right
                    onCheckedChanged: {
                        Core.settings.markNotAssociatedStrings = markNotAssociatedStringsCheckbox.checked
                    }

                    Component.onCompleted: checked = markNotAssociatedStrings
                }
            }

            ThinDivider { }

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: units.gu(3)

                Label {
                    anchors.left: parent.left
                    anchors.verticalCenter: disableNotAssociatedStringsCheckbox.verticalCenter
                    // TRANSLATORS: In the settings page. Section guitar: if true, the not associated chord string can not be played.
                    text: i18n.tr("Disable not associated chord strings")
                }

                Switch {
                    id: disableNotAssociatedStringsCheckbox
                    anchors.right: parent.right
                    onCheckedChanged: {
                        Core.settings.disableNotAssociatedStrings = disableNotAssociatedStringsCheckbox.checked
                    }

                    Component.onCompleted: checked = disableNotAssociatedStrings
                }
            }

            ThinDivider { }

            Label {
                Layout.alignment: Qt.AlignHCenter
                font.bold: true
                fontSize: "large"
                // TRANSLATORS: In the settings page the metronome volume.
                text: i18n.tr("Audio input")
            }

            ThinDivider { }

            Label {
                // TRANSLATORS: In the settings page the microphone volume.
                text: i18n.tr("Microphone volume") + " ( " + Math.round(micorphoneVolumeSlider.value) + "% )"
            }

            RowLayout {
                Layout.fillWidth: true

                Icon {
                    Layout.minimumWidth: units.gu(3)
                    implicitHeight: units.gu(3)
                    implicitWidth: width
                    name: "audio-input-microphone-muted-symbolic"
                    MouseArea {
                        anchors.fill: parent
                        onClicked: micorphoneVolumeSlider.value = micorphoneVolumeSlider.minimumValue
                    }
                }

                Slider {
                    id: micorphoneVolumeSlider
                    Layout.fillWidth: true
                    minimumValue: 0
                    maximumValue: 100
                    onValueChanged: Core.settings.microphoneVolume = Math.round(value)
                    Component.onCompleted: micorphoneVolumeSlider.value = microphoneVolume
                }

                Icon {
                    Layout.minimumWidth: units.gu(3)
                    implicitHeight: units.gu(3)
                    implicitWidth: width
                    name: "audio-input-microphone-symbolic"
                    MouseArea {
                        anchors.fill: parent
                        onClicked: micorphoneVolumeSlider.value = micorphoneVolumeSlider.maximumValue
                    }
                }
            }

            ProgressBar {
                id: volumeProgressBar
                Layout.fillWidth: true
                minimumValue: 0
                maximumValue: 100
                value: Core.settings.currentMicrophoneVolume
            }

            ThinDivider { }

            Label {
                Layout.alignment: Qt.AlignHCenter
                font.bold: true
                fontSize: "large"
                // TRANSLATORS: In the settings page the metronome volume.
                text: i18n.tr("Audio output")
            }

            ThinDivider { }

            Label {
                // TRANSLATORS: In the settings page the metronome volume.
                text: i18n.tr("Metronome volume") + " ( " + Math.round(metronomeVolumeSlider.value) + "% )"
            }

            RowLayout {
                Layout.fillWidth: true

                Icon {
                    Layout.minimumWidth: units.gu(3)
                    implicitHeight: units.gu(3)
                    implicitWidth: width
                    name: "audio-speakers-muted-symbolic"
                    MouseArea {
                        anchors.fill: parent
                        onClicked: metronomeVolumeSlider.value = metronomeVolumeSlider.minimumValue
                    }
                }

                Slider {
                    id: metronomeVolumeSlider
                    Layout.fillWidth: true
                    minimumValue: 0
                    maximumValue: 100
                    value: metronomeVolume
                    onValueChanged: Core.settings.metronomeVolume = Math.round(value)
                }

                Icon {
                    Layout.minimumWidth: units.gu(3)
                    implicitHeight: units.gu(3)
                    implicitWidth: width
                    name: "audio-speakers-symbolic"
                    MouseArea {
                        anchors.fill: parent
                        onClicked: metronomeVolumeSlider.value = metronomeVolumeSlider.maximumValue
                    }
                }

            }

            ThinDivider { }

            Label {
                // TRANSLATORS: In the settings page the guitar player volume.
                text: i18n.tr("Guitar volume") + " ( " + Math.round(guitarPlayerVolumeSlider.value) + "% )"
            }

            RowLayout {
                Layout.fillWidth: true

                Icon {
                    Layout.minimumWidth: units.gu(3)
                    implicitHeight: units.gu(3)
                    implicitWidth: width
                    name: "audio-speakers-muted-symbolic"
                    MouseArea {
                        anchors.fill: parent
                        onClicked: guitarPlayerVolumeSlider.value = guitarPlayerVolumeSlider.minimumValue
                    }
                }

                Slider {
                    id: guitarPlayerVolumeSlider
                    Layout.fillWidth: true
                    minimumValue: 0
                    maximumValue: 100
                    value: guitarPlayerVolume
                    onValueChanged: Core.settings.guitarPlayerVolume = Math.round(value)
                    Component.onCompleted: guitarPlayerVolumeSlider.value = guitarPlayerVolume
                }


                Icon {
                    Layout.minimumWidth: units.gu(3)
                    implicitHeight: units.gu(3)
                    implicitWidth: width
                    name: "audio-speakers-symbolic"
                    MouseArea {
                        anchors.fill: parent
                        onClicked: guitarPlayerVolumeSlider.value = guitarPlayerVolumeSlider.maximumValue
                    }
                }
            }

            ThinDivider { }

            Label {
                // TRANSLATORS: In the settings page the drum loops volume.
                text: i18n.tr("Drum loops volume") + " ( " + Math.round(drumLoopsVolumeSlider.value) + "% )"
            }

            RowLayout {
                Layout.fillWidth: true

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

            ThinDivider { }

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: units.gu(5)

                UbuntuShape {
                    id: color1Shape
                    height: parent.height
                    width: height
                    anchors.left: parent.left
                    anchors.top: parent.top
                    color: root.color1
                    MouseArea {
                        anchors.fill: parent
                        onClicked: Core.increaseColor1()
                    }
                }

                UbuntuShape {
                    id: color2Shape
                    height: parent.height
                    width: height
                    anchors.centerIn: parent
                    color: root.color2
                    MouseArea {
                        anchors.fill: parent
                        onClicked: Core.increaseColor2()
                    }
                }

                UbuntuShape {
                    id: color3Shape
                    height: parent.height
                    width: height
                    anchors.right: parent.right
                    anchors.top: parent.top
                    color: root.color3
                    MouseArea {
                        anchors.fill: parent
                        onClicked: Core.increaseColor3()
                    }
                }
            }

            ThinDivider { }


            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: units.gu(10)

                Rectangle {
                    width: parent.height
                    height: parent.width
                    anchors.centerIn: parent
                    rotation: 90
                    radius: units.gu(1)
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: root.color3 }
                        GradientStop { position: 0.5; color: root.color2 }
                        GradientStop { position: 1.0; color: root.color1 }
                    }
                }

                Image {
                    id: scaleImageLeft
                    anchors.top: parent.top
                    anchors.left: parent.left
                    height: parent.height
                    fillMode: Image.PreserveAspectFit
                    source: "file://" + dataDirectory + "images/note-scale-1.svg"
                }

                Image {
                    id: scaleImageMiddle
                    anchors.centerIn: parent
                    height: parent.height
                    fillMode: Image.PreserveAspectFit
                    source: "file://" + dataDirectory + "images/note-scale-3.svg"
                }

                Image {
                    id: scaleRight
                    anchors.top: parent.top
                    anchors.right: parent.right
                    height: parent.height
                    fillMode: Image.PreserveAspectFit
                    source: "file://" + dataDirectory + "images/note-scale-4.svg"
                }

                Repeater {
                    id: noteLines
                    anchors.fill: parent
                    model: 5
                    delegate: Rectangle {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        height: parent.height / 120
                        color: "black"
                        x: 0
                        y: (4 * parent.height / 12) + (index * parent.height / 12)
                    }
                }
            }

            ThinDivider { }
        }
    }

}

