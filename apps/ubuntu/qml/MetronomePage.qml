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
import Ubuntu.Components 1.3
import Ubuntu.Components.ListItems 1.3
import GuitarTools 1.0
import "components"

Page {
    id: root
    header: PageHeader {
        id: pageHeader
        // TRANSLATORS: Title of the metronome page
        title: i18n.tr("Metronome")
        trailingActionBar.actions: [
            Action {
                iconName: "info"
                onTriggered: pageLayout.addPageToCurrentColumn(root, Qt.resolvedUrl("AboutPage.qml"))
            }
        ]
    }

    property bool landscape: width > height

    property int bpm: Core.metronome.bpm
    property int duration: Core.metronome.period * 1.02
    property real metronomeVolume: Core.settings.metronomeVolume / 100
    property real angle: angleMax
    property real angleMin: 25
    property real angleMax: -25

    Component.onDestruction: Core.metronome.stop()

    SoundEffect {
        id: tickSound
        source: "file://" + dataDirectory + "sounds/metronome/tick.wav"
        volume: metronomeVolume
    }

    SoundEffect {
        id: tockSound
        source: "file://" + dataDirectory + "sounds/metronome/tock.wav"
        volume: metronomeVolume
    }

    NumberAnimation {
        id: pendulumTickAnimation
        target: root
        easing.type: Easing.InOutQuad
        property: "angle"
        from: root.angleMax
        to: root.angleMin
        duration: root.duration
    }

    NumberAnimation {
        id: pendulumTockAnimation
        target: root
        easing.type: Easing.InOutQuad
        property: "angle"
        from: root.angleMin
        to: root.angleMax
        duration: root.duration
    }

    Connections {
        target: Core.metronome
        onTick: {
            tickSound.play()
            pendulumTickAnimation.start()
        }
        onTock: {
            tockSound.play()
            pendulumTockAnimation.start()
        }
    }

    Connections {
        target: Qt.application
        onActiveChanged: {
            if (!Qt.application.active)
                Core.metronome.stop()
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.topMargin: pageHeader.height + units.gu(2)
        anchors.bottom: parent.bottom
        anchors.bottomMargin: units.gu(2)

        spacing: units.gu(2)

        Label {
            Layout.alignment: Qt.AlignHCenter
            font.pixelSize: units.gu(5)
            font.bold: true
            color: theme.palette.normal.baseText
            text: Math.round(bpmSlider.value)
        }

        Label {
            id: dtLabel
            Layout.alignment: Qt.AlignHCenter
            font.bold: true
            font.pixelSize: units.gu(2)
            visible: Core.settings.debugEnabled
            color: theme.palette.normal.baseText
            text: Math.round(60000 / bpmSlider.value) + " [ms]"
        }

        Image {
            id: metronomeBackgroundImage
            fillMode: Image.PreserveAspectFit
            Layout.alignment: Qt.AlignHCenter
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.maximumWidth: parent.width
            Layout.maximumHeight: parent.height

            property real widthOffset: (metronomeBackgroundImage.width - metronomeBackgroundImage.paintedWidth) / 2
            property real heightOffset: (metronomeBackgroundImage.height - metronomeBackgroundImage.paintedHeight) / 2

            source: "file://" + dataDirectory + "images/metronome.png"

            Column {
                anchors.left: parent.left
                anchors.right: parent.right

                anchors.bottom: metronomeBackgroundImage.bottom
                anchors.bottomMargin: (metronomeBackgroundImage.paintedWidth * 0.01) + metronomeBackgroundImage.heightOffset

                Rectangle {
                    id: playPauseButton
                    anchors.horizontalCenter: parent.horizontalCenter
                    height: metronomeBackgroundImage.paintedWidth / 4
                    width: height
                    color: "transparent"

                    Icon {
                        anchors.fill: parent
                        anchors.margins: units.gu(2)
                        implicitHeight: metronomeBackgroundImage.paintedWidth / 5
                        implicitWidth: width
                        name: Core.metronome.running ? "media-playback-pause" : "media-playback-start"
                    }

                    MouseArea {
                        id: playPauseMouseArea
                        anchors.fill: parent
                        onClicked: {
                            if (Core.metronome.running) {
                                Core.metronome.stop()
                            } else {
                                Core.metronome.start()
                            }
                        }
                    }
                }

                Label {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: Core.metronome.tempoName
                }
            }

            Item {
                id: metronomePendulum
                anchors.horizontalCenter: metronomeBackgroundImage.horizontalCenter
                anchors.bottom: metronomeBackgroundImage.bottom
                anchors.bottomMargin: metronomeBackgroundImage.heightOffset
                height: metronomePendulumImage.height
                width: metronomePendulumImage.implicitWidth

                transform: Rotation {
                    origin {
                        x: metronomePendulumImage.width / 2
                        y: metronomePendulumImage.height - height * 0.05
                    }
                    axis { x: 0; y: 0; z: 1 }
                    angle: root.angle
                }

                Image {
                    id: metronomePendulumImage
                    height: metronomeBackgroundImage.paintedHeight
                    fillMode: Image.PreserveAspectFit
                    source: "file://" + dataDirectory + "images/metronome-pendulum.png"
                }

                Image {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.topMargin: (height / 2 ) * (bpmSlider.value - 40) / 168

                    Behavior on anchors.topMargin {
                        NumberAnimation { duration: root.duration / 2 }
                    }

                    fillMode: Image.PreserveAspectFit
                    source: "file://" + dataDirectory + "images/metronome-weight.png"
                }
            }

        }

        Slider {
            id: bpmSlider
            anchors.left: parent.left
            anchors.leftMargin: units.gu(3)
            anchors.right: parent.right
            anchors.rightMargin: units.gu(3)
            minimumValue: 40
            maximumValue: 208
            value: bpm
            onValueChanged: {
                Core.settings.metronomeSpeed = Math.round(bpmSlider.value)
                Core.metronome.bpm = Math.round(bpmSlider.value)
            }
        }
    }

    MetronomeBottomEdge { id: bottomEdge }
}


