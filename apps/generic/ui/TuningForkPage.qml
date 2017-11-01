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
import GuitarTools 1.0

Page {
    id: root
    header: PageHeader {
        id: pageHeader
        // TRANSLATORS: Title of the tuning fork page
        title: i18n.tr("Tuning fork")
        trailingActionBar.actions: [
            Action {
                iconName: "info"
                onTriggered: pageLayout.addPageToCurrentColumn(root, Qt.resolvedUrl("AboutPage.qml"))
            }
        ]
    }

    Component.onDestruction: {
        Core.sineWaveGenerator.stop()
        Core.activateGuitarTuner()
    }

    property real tuningForkVolume: Core.settings.tuningForkVolume
    property real tuningForkFrequency: Core.settings.tuningForkFrequency
    property real frequencyPercentage: (frequencySlider.value - frequencySlider.minimumValue) / (frequencySlider.maximumValue - frequencySlider.minimumValue)
    property int animationDuration: Math.abs((500 / (frequencyPercentage + 0.5)))

    onAnimationDurationChanged: {
        if (Core.sineWaveGenerator.running) {
            // FIXME
            console.log("animation ms" + animationDuration)
            soundAnimation.restart()
        }
    }

    Label {
        id: frequencyLabel
        anchors.top: pageHeader.bottom
        anchors.topMargin: units.gu(5)
        anchors.horizontalCenter: parent.horizontalCenter
        font.bold: true
        font.pixelSize: units.gu(4)
        text: Math.round(Core.sineWaveGenerator.frequency) + " [Hz]"
        color: theme.palette.normal.baseText
    }

    ColumnLayout {
        anchors.top: frequencyLabel.bottom
        anchors.topMargin: units.gu(5)
        anchors.left:  parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.bottomMargin: units.gu(5)

        spacing: units.gu(5)

        Item {
            Layout.alignment: Qt.AlignHCenter
            // Squared image
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.minimumWidth: units.gu(30)
            Layout.minimumHeight: units.gu(30)

            Image {
                id: forkZero
                anchors.fill: parent
                fillMode: Image.PreserveAspectFit
                source: "file://" + dataDirectory + "images/tuning-fork-0.svg"
            }

            Image {
                id: forkOne
                anchors.fill: parent
                fillMode: Image.PreserveAspectFit
                opacity: 0
                source: "file://" + dataDirectory + "images/tuning-fork-1.svg"
            }

            Image {
                id: forkTwo
                anchors.fill: parent
                fillMode: Image.PreserveAspectFit
                opacity: 0
                source: "file://" + dataDirectory + "images/tuning-fork-2.svg"
            }

            Image {
                id: forkThree
                anchors.fill: parent
                fillMode: Image.PreserveAspectFit
                opacity: 0
                source: "file://" + dataDirectory + "images/tuning-fork-3.svg"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (Core.sineWaveGenerator.running) {
                        Core.sineWaveGenerator.stop()
                        soundAnimation.stop()
                        forkOne.opacity = 0
                        forkTwo.opacity = 0
                        forkThree.opacity = 0
                    } else {
                        Core.sineWaveGenerator.play()
                        soundAnimation.start()
                    }
                }
            }

            SequentialAnimation {
                id: soundAnimation
                loops: Animation.Infinite

                ParallelAnimation {
                    PropertyAnimation {
                        target: forkOne
                        property: "opacity"
                        to: 0.5
                        duration: animationDuration
                    }

                    PropertyAnimation {
                        target: forkTwo
                        property: "opacity"
                        to: 0
                        duration: animationDuration
                    }

                    PropertyAnimation {
                        target: forkThree
                        property: "opacity"
                        to: 0
                        duration: animationDuration
                    }
                }

                ParallelAnimation {
                    PropertyAnimation {
                        target: forkOne
                        property: "opacity"
                        to: 1
                        duration: animationDuration
                    }

                    PropertyAnimation {
                        target: forkTwo
                        property: "opacity"
                        to: 0.5
                        duration: animationDuration
                    }

                    PropertyAnimation {
                        target: forkThree
                        property: "opacity"
                        to: 0
                        duration: animationDuration
                    }
                }

                ParallelAnimation {
                    PropertyAnimation {
                        target: forkOne
                        property: "opacity"
                        to: 0.5
                        duration: animationDuration
                    }

                    PropertyAnimation {
                        target: forkTwo
                        property: "opacity"
                        to: 1
                        duration: animationDuration
                    }

                    PropertyAnimation {
                        target: forkThree
                        property: "opacity"
                        to: 0.5
                        duration: animationDuration / 2
                    }
                }

                ParallelAnimation {
                    PropertyAnimation {
                        target: forkOne
                        property: "opacity"
                        to: 0
                        duration: animationDuration
                    }

                    PropertyAnimation {
                        target: forkTwo
                        property: "opacity"
                        to: 0.5
                        duration: animationDuration
                    }

                    PropertyAnimation {
                        target: forkThree
                        property: "opacity"
                        to: 1
                        duration: animationDuration
                    }
                }

                ParallelAnimation {
                    PropertyAnimation {
                        target: forkOne
                        property: "opacity"
                        to: 0
                        duration: animationDuration
                    }

                    PropertyAnimation {
                        target: forkTwo
                        property: "opacity"
                        to: 0
                        duration: animationDuration
                    }

                    PropertyAnimation {
                        target: forkThree
                        property: "opacity"
                        to: 0.5
                        duration: animationDuration
                    }
                }
            }
        }

        Column {
            anchors.left: parent.left
            anchors.right: parent.right
            spacing: units.gu(1)

            RowLayout {
                anchors.left: parent.left
                anchors.leftMargin: units.gu(2)
                anchors.right: parent.right
                anchors.rightMargin: units.gu(2)

                Icon {
                    Layout.minimumWidth: units.gu(3)
                    implicitHeight: units.gu(3)
                    implicitWidth: width
                    name: "audio-speakers-muted-symbolic"
                    MouseArea {
                        anchors.fill: parent
                        onClicked: volumeSlider.value = volumeSlider.minimumValue
                    }
                }

                Slider {
                    id: volumeSlider
                    Layout.fillWidth: true
                    minimumValue: 0
                    maximumValue: 100
                    onValueChanged: {
                        Core.sineWaveGenerator.volume = value / 100
                        Core.settings.tuningForkVolume = value
                    }
                    Component.onCompleted: volumeSlider.value = tuningForkVolume
                }

                Icon {
                    Layout.minimumWidth: units.gu(3)
                    implicitHeight: units.gu(3)
                    implicitWidth: width
                    name: "audio-speakers-symbolic"
                    MouseArea {
                        anchors.fill: parent
                        onClicked: volumeSlider.value = volumeSlider.maximumValue
                    }
                }
            }

            RowLayout {
                anchors.left: parent.left
                anchors.leftMargin: units.gu(2)
                anchors.right: parent.right
                anchors.rightMargin: units.gu(2)

                Icon {
                    Layout.minimumWidth: units.gu(3)
                    implicitHeight: units.gu(3)
                    implicitWidth: width
                    source: "file://" + dataDirectory + "icons/frequency-low.svg"
                    MouseArea {
                        anchors.fill: parent
                        onClicked: frequencySlider.value = frequencySlider.minimumValue
                    }
                }

                Slider {
                    id: frequencySlider
                    Layout.fillWidth: true
                    minimumValue: 300
                    maximumValue: 500
                    value: 440
                    onValueChanged: {
                        Core.sineWaveGenerator.frequency = Math.round(value)
                        Core.settings.tuningForkFrequency = Math.round(value)
                    }
                    Component.onCompleted: frequencySlider.value = tuningForkFrequency
                }

                Icon {
                    Layout.minimumWidth: units.gu(3)
                    implicitHeight: units.gu(3)
                    implicitWidth: width
                    source: "file://" + dataDirectory + "icons/frequency-high.svg"
                    MouseArea {
                        anchors.fill: parent
                        onClicked: frequencySlider.value = frequencySlider.maximumValue
                    }
                }
            }
        }
    }
}
