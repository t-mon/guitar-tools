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
                text: qsTr("Tuning fork")
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

    Component.onDestruction: {
        Core.sineWaveGenerator.stop()
        Core.activateGuitarTuner()
    }

    property real tuningForkVolume: Core.settings.tuningForkVolume
    property real tuningForkFrequency: Core.settings.tuningForkFrequency
    property real frequencyPercentage: (frequencySlider.value - frequencySlider.from) / (frequencySlider.to - frequencySlider.from)
    property int animationDuration: Math.abs((500 / (frequencyPercentage + 0.5)))

    onAnimationDurationChanged: {
        if (Core.sineWaveGenerator.running) {
            // FIXME
            console.log("animation ms" + animationDuration)
            soundAnimation.restart()
        }
    }

    Item {
        anchors.fill: parent
        anchors.leftMargin: 5
        anchors.rightMargin: 5
        anchors.topMargin: 10
        anchors.bottomMargin: 10

        ColumnLayout {
            anchors.fill: parent
            spacing: 5

            Label {
                id: frequencyLabel
                Layout.alignment: Qt.AlignHCenter
                font.pixelSize: 40
                text: Math.round(Core.sineWaveGenerator.frequency) + " Hz"
                color: Material.foreground
            }


            Item {
                Layout.alignment: Qt.AlignHCenter
                // Squared image
                Layout.fillHeight: true
                Layout.fillWidth: true

                Image {
                    id: forkZero
                    anchors.fill: parent
                    fillMode: Image.PreserveAspectFit
                    source: dataDirectory + "/images/tuning-fork-0.svg"
                }

                Image {
                    id: forkOne
                    anchors.fill: parent
                    fillMode: Image.PreserveAspectFit
                    opacity: 0
                    source: dataDirectory + "/images/tuning-fork-1.svg"
                }

                Image {
                    id: forkTwo
                    anchors.fill: parent
                    fillMode: Image.PreserveAspectFit
                    opacity: 0
                    source: dataDirectory + "/images/tuning-fork-2.svg"
                }

                Image {
                    id: forkThree
                    anchors.fill: parent
                    fillMode: Image.PreserveAspectFit
                    opacity: 0
                    source: dataDirectory + "/images/tuning-fork-3.svg"
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

            SineWaveIndicator {
                id: sineWave
                anchors.left: parent.left
                anchors.leftMargin: 5
                anchors.right: parent.right
                anchors.rightMargin: 5
                indicatorValue: volumeSlider.value / 2
                speed: 1
                running: Core.sineWaveGenerator.running
                opacity: Core.sineWaveGenerator.running ? 1 : 0
                frequency: frequencySlider.value
            }


            RowLayout {
                anchors.left: parent.left
                anchors.leftMargin: 5
                anchors.right: parent.right
                anchors.rightMargin: 5

                IconToolButton {
                    iconSource: dataDirectory + "/icons/audio-speakers-muted-symbolic.svg"
                    onClicked: volumeSlider.value = volumeSlider.from
                }

                Slider {
                    id: volumeSlider
                    Layout.fillWidth: true
                    from: 0
                    to: 100
                    onValueChanged: {
                        Core.sineWaveGenerator.volume = value / 100
                        Core.settings.tuningForkVolume = value
                    }
                    Component.onCompleted: volumeSlider.value = tuningForkVolume
                }

                IconToolButton {
                    iconSource: dataDirectory + "/icons/audio-speakers-symbolic.svg"
                    onClicked: volumeSlider.value = volumeSlider.to
                }
            }

            RowLayout {
                anchors.left: parent.left
                anchors.leftMargin: 5
                anchors.right: parent.right
                anchors.rightMargin: 5

                IconToolButton {
                    iconSource: dataDirectory + "/icons/frequency-low.svg"
                    onClicked: frequencySlider.value = frequencySlider.from
                }

                Slider {
                    id: frequencySlider
                    Layout.fillWidth: true
                    from: 300
                    to: 500
                    value: 440
                    onValueChanged: {
                        Core.sineWaveGenerator.frequency = Math.round(value)
                        Core.settings.tuningForkFrequency = Math.round(value)
                    }
                    Component.onCompleted: frequencySlider.value = tuningForkFrequency
                }

                IconToolButton {
                    iconSource: dataDirectory + "/icons/frequency-high.svg"
                    onClicked: frequencySlider.value = frequencySlider.to
                }
            }
        }
    }
}
