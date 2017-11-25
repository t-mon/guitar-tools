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

import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtMultimedia 5.9
import QtQuick.Controls.Material 2.2

import GuitarTools 1.0
import "components"

Page {
    id: root
    header: ToolBar {
        RowLayout {
            anchors.fill: parent
            IconToolButton {
                iconSource: dataDirectory + "/icons/back.svg"
                onClicked: pageStack.pop()
            }

            Label {
                text: qsTr("Settings")
                elide: Label.ElideRight
                verticalAlignment: Qt.AlignVCenter
                Layout.fillWidth: true
            }

            IconToolButton {
                iconSource: dataDirectory + "/icons/info.svg"
                onClicked: pageStack.push(Qt.resolvedUrl("AboutPage.qml"))
            }
        }
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
    property real pitchStandard: Core.settings.pitchStandard
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
            anchors.leftMargin: 5
            anchors.right: parent.right
            anchors.rightMargin: 5

            spacing: 2

            MenuSeparator { anchors.left: parent.left; anchors.right: parent.right }

            Label {
                Layout.alignment: Qt.AlignHCenter
                font.bold: true
                // TRANSLATORS: In the settings page the metronome volume.
                text: qsTr("General settings")
            }

            MenuSeparator { anchors.left: parent.left; anchors.right: parent.right }


            RowLayout {
                Layout.fillWidth: true

                Label {
                    Layout.alignment: Qt.AlignVCenter
                    Layout.fillWidth: true
                    // TRANSLATORS: In the settings page the Debug checkbox description.
                    text: qsTr("Show details")
                }

                Switch {
                    id: debugCheckbox
                    Layout.alignment: Qt.AlignVCenter
                    onCheckedChanged: {
                        Core.settings.debugEnabled = debugCheckbox.checked
                    }

                    Component.onCompleted: checked = debug
                }
            }

            //MenuSeparator { anchors.left: parent.left; anchors.right: parent.right }

            RowLayout {
                Layout.fillWidth: true

                Label {
                    Layout.alignment: Qt.AlignVCenter
                    Layout.fillWidth: true
                    // TRANSLATORS: In the settings page the screen saver checkbox description.
                    text: qsTr("Disable screen saver")
                }

                Switch {
                    id: screensaverCheckbox
                    Layout.alignment: Qt.AlignVCenter
                    onCheckedChanged: {
                        Core.settings.disableScreensaver = screensaverCheckbox.checked
                    }
                    Component.onCompleted: checked = disableScreensaver
                }
            }

            // MenuSeparator { anchors.left: parent.left; anchors.right: parent.right }

            RowLayout {
                Layout.fillWidth: true

                Label {
                    Layout.alignment: Qt.AlignVCenter
                    Layout.fillWidth: true
                    // TRANSLATORS: In the settings page the dark theme checkbox description.
                    text: qsTr("Dark theme")
                }

                Switch {
                    id: darkThemeCheckbox
                    Layout.alignment: Qt.AlignVCenter
                    onCheckedChanged: {
                        Core.settings.darkThemeEnabled = darkThemeCheckbox.checked
                    }
                    Component.onCompleted: checked = darkThemeEnabled
                }
            }

            MenuSeparator { anchors.left: parent.left; anchors.right: parent.right }


            Label {
                // TRANSLATORS: In the settings page the chord player delay.
                text: qsTr("Chord player delay") + " [ " + Math.round(chordPlayerSlider.value) + "ms ]"
            }

            RowLayout {
                anchors.left: parent.left
                anchors.right: parent.right

                IconToolButton {
                    iconSource: dataDirectory + "/icons/remove.svg"
                    onClicked: chordPlayerSlider.value = chordPlayerSlider.from
                }

                Slider {
                    id: chordPlayerSlider
                    Layout.fillWidth: true
                    from: 0
                    to: 1000
                    value: chordPlayerDelay
                    onValueChanged: Core.settings.chordPlayerDelay = Math.round(value)
                    Component.onCompleted: chordPlayerSlider.value = chordPlayerDelay
                }

                IconToolButton {
                    iconSource: dataDirectory + "/icons/add.svg"
                    onClicked: chordPlayerSlider.value = chordPlayerSlider.to
                }
            }

            MenuSeparator { anchors.left: parent.left; anchors.right: parent.right }


            Label {
                Layout.alignment: Qt.AlignHCenter
                font.bold: true
                // TRANSLATORS: In the settings page the metronome volume.
                text: qsTr("Guitar tuner")
            }

            MenuSeparator { anchors.left: parent.left; anchors.right: parent.right }

            Label {
                Layout.alignment: Qt.AlignLeft
                // TRANSLATORS: In the settings page the pitch standard selection
                text: qsTr("Pitch standard")
            }

            ComboBox {
                id: pitchStandardSelector
                Layout.fillWidth: true
                displayText: currentText + " Hz"
                model: [434, 440]
                onCurrentIndexChanged: {
                    if (currentIndex === 0)
                        Core.settings.pitchStandard = 434

                    if (currentIndex === 1)
                        Core.settings.pitchStandard = 440
                }

                onModelChanged: {
                    if (pitchStandard === 434)
                        currentIndex = 0

                    if (pitchStandard === 440)
                        currentIndex = 1
                }
            }

            MenuSeparator { anchors.left: parent.left; anchors.right: parent.right }


            Label {
                Layout.alignment: Qt.AlignHCenter
                font.bold: true
                text: qsTr("Guitar")
            }

            MenuSeparator { anchors.left: parent.left; anchors.right: parent.right }

            RowLayout {
                Layout.fillWidth: true

                Label {
                    Layout.alignment: Qt.AlignVCenter
                    Layout.fillWidth: true
                    // TRANSLATORS: In the settings page. Section guitar: if true, the not associated chord string will be marked red.
                    text: qsTr("Mark not associated chord strings")
                }

                Switch {
                    id: markNotAssociatedStringsCheckbox
                    Layout.alignment: Qt.AlignVCenter
                    Layout.fillWidth: true
                    onCheckedChanged: {
                        Core.settings.markNotAssociatedStrings = markNotAssociatedStringsCheckbox.checked
                    }

                    Component.onCompleted: checked = markNotAssociatedStrings
                }
            }

            MenuSeparator { anchors.left: parent.left; anchors.right: parent.right }


            RowLayout {
                Layout.fillWidth: true

                Label {
                    Layout.alignment: Qt.AlignVCenter
                    Layout.fillWidth: true
                    // TRANSLATORS: In the settings page. Section guitar: if true, the not associated chord string can not be played.
                    text: qsTr("Disable not associated chord strings")
                }

                Switch {
                    id: disableNotAssociatedStringsCheckbox
                    Layout.alignment: Qt.AlignVCenter
                    Layout.fillWidth: true

                    onCheckedChanged: {
                        Core.settings.disableNotAssociatedStrings = disableNotAssociatedStringsCheckbox.checked
                    }

                    Component.onCompleted: checked = disableNotAssociatedStrings
                }
            }

            MenuSeparator { anchors.left: parent.left; anchors.right: parent.right }


            Label {
                Layout.alignment: Qt.AlignHCenter
                font.bold: true
                // TRANSLATORS: In the settings page the metronome volume.
                text: qsTr("Audio input")
            }

            MenuSeparator { anchors.left: parent.left; anchors.right: parent.right }


            Label {
                // TRANSLATORS: In the settings page the microphone volume.
                text: qsTr("Microphone volume") + " ( " + Math.round(microphoneVolumeSlider.value) + "% )"
            }

            RowLayout {
                Layout.fillWidth: true

                IconToolButton {
                    iconSource: dataDirectory + "/icons/audio-speakers-muted-symbolic.svg"
                    onClicked: microphoneVolumeSlider.value = microphoneVolumeSlider.from
                }

                Slider {
                    id: microphoneVolumeSlider
                    Layout.fillWidth: true
                    from: 0
                    to: 100
                    value: microphoneVolume
                    onValueChanged: Core.settings.microphoneVolume = Math.round(value)
                    Component.onCompleted: microphoneVolumeSlider.value = microphoneVolume
                }

                IconToolButton {
                    iconSource: dataDirectory + "/icons/audio-speakers-symbolic.svg"
                    onClicked: microphoneVolumeSlider.value = microphoneVolumeSlider.to
                }
            }

            ProgressBar {
                id: volumeProgressBar
                Layout.fillWidth: true
                from: 0
                to: 100
                value: Core.settings.currentMicrophoneVolume
            }

            MenuSeparator { anchors.left: parent.left; anchors.right: parent.right }

            Label {
                Layout.alignment: Qt.AlignHCenter
                font.bold: true
                // TRANSLATORS: In the settings page the metronome volume.
                text: qsTr("Audio output")
            }

            MenuSeparator { anchors.left: parent.left; anchors.right: parent.right }


            Label {
                // TRANSLATORS: In the settings page the metronome volume.
                text: qsTr("Metronome volume") + " ( " + Math.round(metronomeVolumeSlider.value) + "% )"
            }

            RowLayout {
                anchors.left: parent.left
                anchors.right: parent.right

                IconToolButton {
                    iconSource: dataDirectory + "/icons/audio-speakers-muted-symbolic.svg"
                    onClicked: metronomeVolumeSlider.value = metronomeVolumeSlider.from
                }

                Slider {
                    id: metronomeVolumeSlider
                    Layout.fillWidth: true
                    from: 0
                    to: 100
                    value: metronomeVolume
                    onValueChanged: Core.settings.metronomeVolume = Math.round(value)
                    Component.onCompleted: metronomeVolumeSlider.value = metronomeVolume
                }

                IconToolButton {
                    iconSource: dataDirectory + "/icons/audio-speakers-symbolic.svg"
                    onClicked: metronomeVolumeSlider.value = metronomeVolumeSlider.to
                }
            }

            MenuSeparator { anchors.left: parent.left; anchors.right: parent.right }

            Label {
                // TRANSLATORS: In the settings page the guitar player volume.
                text: qsTr("Guitar volume") + " ( " + Math.round(guitarPlayerVolumeSlider.value) + "% )"
            }

            RowLayout {
                anchors.left: parent.left
                anchors.right: parent.right

                IconToolButton {
                    iconSource: dataDirectory + "/icons/audio-speakers-muted-symbolic.svg"
                    onClicked: guitarPlayerVolumeSlider.value = guitarPlayerVolumeSlider.from
                }

                Slider {
                    id: guitarPlayerVolumeSlider
                    Layout.fillWidth: true
                    from: 0
                    to: 100
                    value: guitarPlayerVolume
                    onValueChanged: Core.settings.guitarPlayerVolume = Math.round(value)
                    Component.onCompleted: guitarPlayerVolumeSlider.value = guitarPlayerVolume
                }

                IconToolButton {
                    iconSource: dataDirectory + "/icons/audio-speakers-symbolic.svg"
                    onClicked: guitarPlayerVolumeSlider.value = guitarPlayerVolumeSlider.to
                }
            }

//            MenuSeparator { anchors.left: parent.left; anchors.right: parent.right }

//            Label {
//                // TRANSLATORS: In the settings page the drum loops volume.
//                text: qsTr("Drum loops volume") + " ( " + Math.round(drumLoopsVolumeSlider.value) + "% )"
//            }

//            RowLayout {
//                Layout.fillWidth: true

//                Icon {
//                    Layout.minimumWidth: units.gu(3)
//                    implicitHeight: units.gu(3)
//                    implicitWidth: width
//                    name: "audio-speakers-muted-symbolic"
//                    MouseArea {
//                        anchors.fill: parent
//                        onClicked: drumLoopsVolumeSlider.value = drumLoopsVolumeSlider.minimumValue
//                    }
//                }

//                Slider {
//                    id: drumLoopsVolumeSlider
//                    Layout.fillWidth: true
//                    minimumValue: 0
//                    maximumValue: 100
//                    value: drumLoopsVolume
//                    onValueChanged: Core.settings.drumLoopsVolume = Math.round(value)
//                }

//                Icon {
//                    Layout.minimumWidth: units.gu(3)
//                    implicitHeight: units.gu(3)
//                    implicitWidth: width
//                    name: "audio-speakers-symbolic"
//                    MouseArea {
//                        anchors.fill: parent
//                        onClicked: drumLoopsVolumeSlider.value = drumLoopsVolumeSlider.maximumValue
//                    }
//                }
//            }

            MenuSeparator { anchors.left: parent.left; anchors.right: parent.right }

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: 50

                Rectangle {
                    id: color1Shape
                    height: parent.height
                    width: height
                    anchors.left: parent.left
                    anchors.top: parent.top
                    radius: height / 3
                    color: root.color1
                    MouseArea {
                        anchors.fill: parent
                        onClicked: Core.increaseColor1()
                    }
                }

                Rectangle {
                    id: color2Shape
                    height: parent.height
                    width: height
                    anchors.centerIn: parent
                    radius: height / 3
                    color: root.color2
                    MouseArea {
                        anchors.fill: parent
                        onClicked: Core.increaseColor2()
                    }
                }

                Rectangle {
                    id: color3Shape
                    height: parent.height
                    width: height
                    radius: height / 3
                    anchors.right: parent.right
                    anchors.top: parent.top
                    color: root.color3
                    MouseArea {
                        anchors.fill: parent
                        onClicked: Core.increaseColor3()
                    }
                }
            }

            MenuSeparator { anchors.left: parent.left; anchors.right: parent.right }

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: 50

                Rectangle {
                    width: parent.height
                    height: parent.width
                    anchors.centerIn: parent
                    rotation: 90
                    radius: 5
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
                    source: dataDirectory + "/images/note-scale-1.svg"
                }

                Image {
                    id: scaleImageMiddle
                    anchors.centerIn: parent
                    height: parent.height
                    fillMode: Image.PreserveAspectFit
                    source: dataDirectory + "/images/note-scale-3.svg"
                }

                Image {
                    id: scaleRight
                    anchors.top: parent.top
                    anchors.right: parent.right
                    height: parent.height
                    fillMode: Image.PreserveAspectFit
                    source: dataDirectory + "/images/note-scale-4.svg"
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

            MenuSeparator { anchors.left: parent.left; anchors.right: parent.right }

        }
    }

}

