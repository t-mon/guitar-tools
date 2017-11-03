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
    title: qsTr("About")

    header: ToolBar {
        RowLayout {
            anchors.fill: parent
            IconToolButton {
                iconSource: dataDirectory + "/icons/back.svg"
                onClicked: pageStack.pop()
            }

            Label {
                text: qsTr("About")
                elide: Label.ElideRight
                verticalAlignment: Qt.AlignVCenter
                Layout.fillWidth: true
            }
        }
    }

    Flickable {
        id: aboutFlickable
        anchors.fill: parent
        anchors.topMargin: root.header.height
        contentHeight: aboutColumn.height

        Column {
            id: aboutColumn
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.right: parent.right
            anchors.rightMargin: 10

            spacing: 6

            Column {
                anchors.left: parent.left
                anchors.right: parent.right
                spacing: 10

                Item {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: 15

                    Label {
                        anchors.centerIn: parent
                        text: "Guitar tools"
                        font.bold: true
                        font.pixelSize: 30
                    }
                }


                Rectangle {
                    id: iconImage
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: 50
                    height: width
                    radius: 10

                    Image {
                        anchors.fill: parent
                        source: dataDirectory + "/icons/guitar-tools.svg"
                    }
                }

                Label {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: version
                    font.bold: true
                    font.pixelSize: 20
                }

                Label {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "2016 © Simon Stürz"
                }

                Separator { }
            }


            Column {
                anchors.left: parent.left
                anchors.right: parent.right
                spacing: 10

                Row {
                    anchors.left: parent.left
                    spacing: 5

                    Label {
                        // TRANSLATORS: In the about screen.
                        text: qsTr("License:")
                        font.bold: true
                    }

                    Label {
                        text: "GPLv3"
                        font.underline: true

                        MouseArea {
                            anchors.fill: parent
                            onClicked: Qt.openUrlExternally("https://www.gnu.org/licenses/gpl-3.0.html")
                        }
                    }
                }

                Row {
                    anchors.left: parent.left
                    spacing: 5

                    Label {
                        // TRANSLATORS: In the about screen.
                        text: qsTr("Source code:")
                        font.bold: true
                    }

                    Label {
                        text: "Launchpad"
                        font.underline: true

                        MouseArea {
                            anchors.fill: parent
                            onClicked: Qt.openUrlExternally("https://code.launchpad.net/guitar-tools")
                        }
                    }
                }

                Row {
                    anchors.left: parent.left
                    spacing: 5

                    Label {
                        // TRANSLATORS: In the about screen.
                        text: qsTr("Bugtracker:")
                        font.bold: true
                    }

                    Label {
                        text: "Launchpad"
                        font.underline: true

                        MouseArea {
                            anchors.fill: parent
                            onClicked: Qt.openUrlExternally("https://bugs.launchpad.net/guitar-tools")
                        }
                    }
                }

                Row {
                    anchors.left: parent.left
                    spacing: 5

                    Label {
                        // TRANSLATORS: Thank you very much for helping with the translations!! :)
                        text: qsTr("Translations:")
                        font.bold: true
                    }

                    Label {
                        text: "Launchpad"
                        font.underline: true

                        MouseArea {
                            anchors.fill: parent
                            onClicked: Qt.openUrlExternally("https://translations.launchpad.net/guitar-tools")
                        }
                    }
                }


                Row {
                    anchors.left: parent.left
                    spacing: 5

                    Label {
                        // TRANSLATORS: In the about screen.
                        text: qsTr("Mail:")
                        font.bold: true
                    }

                    Label {
                        text: "stuerz.simon@gmail.com"
                        font.underline: true

                        MouseArea {
                            anchors.fill: parent
                            onClicked: Qt.openUrlExternally("mailto:stuerz.simon@gmail.com")
                        }
                    }
                }

                Row {
                    anchors.left: parent.left
                    spacing: 5

                    Label {
                        // TRANSLATORS: In the about screen.
                        text: qsTr("Design:")
                        font.bold: true
                    }

                    Label {
                        text: "Simon Stürz"
                    }
                }

                Separator { }

                Label {
                    // TRANSLATORS: Donate button description
                    text: qsTr("Enjoying the app?")
                    font.bold: true
                    wrapMode: Text.WordWrap
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Button {
                    id: donateButton
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    anchors.right: parent.right
                    anchors.rightMargin: 10

//                    background: Rectangle {
//                        anchors.fill: parent
//                        color: app.green
//                    }

                    //color: "green"
                    // TRANSLATORS: Text in the Donate button
                    text: qsTr("Donate (PayPal)")
                    font.underline: true
                    onClicked: Qt.openUrlExternally("https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=C3UKTC3XY9SJ6")
                }

                Separator { }

                Label {
                    id: sounds
                    anchors.left: parent.left
                    anchors.right: parent.right
                    // TRANSLATORS: In the about screen.
                    text: qsTr("Thanks to Fabian Baumgartner and Alfred Bushi for recording the guitar sounds with me. We release the sounds under the <b>CC BY-NC 3.0</b>.")
                    wrapMode: Text.WordWrap
                }

                Separator { }

                Row {
                    anchors.left: parent.left
                    anchors.right: parent.right

                    spacing: 2

                    Label {
                        id: metronomeTitle
                        // TRANSLATORS: In the about screen.
                        text: qsTr("Metronome sounds:")
                        font.bold: true
                    }

                    Label {
                        width: parent.width - metronomeTitle.width - parent.spacing
                        text: "Druminfected (Creative Commons 0)"
                        font.underline: true
                        wrapMode: Text.WordWrap

                        MouseArea {
                            anchors.fill: parent
                            onClicked: Qt.openUrlExternally("http://www.freesound.org/people/Druminfected/packs/15379/")
                        }
                    }
                }

                Separator { }

                Row {
                    anchors.left: parent.left
                    anchors.right: parent.right

                    spacing: 2

                    Label {
                        id: drumLoopsTitle
                        // TRANSLATORS: In the about screen.
                        text: qsTr("Drum loops:")
                        font.bold: true
                    }

                    Label {
                        width: parent.width - drumLoopsTitle.width - parent.spacing
                        text: "Mike Gieson"
                        font.underline: true
                        wrapMode: Text.WordWrap

                        MouseArea {
                            anchors.fill: parent
                            onClicked: Qt.openUrlExternally("http://www.drumbot.com/projects/drumbot/source/")
                        }
                    }
                }

                Separator { }

                Row {
                    anchors.left: parent.left
                    anchors.right: parent.right

                    spacing: 2

                    Label {
                        id: libsTitle
                        // TRANSLATORS: In the about screen.
                        text: qsTr("External library:")
                        font.bold: true
                    }

                    Label {
                        width: parent.width - drumLoopsTitle.width - parent.spacing
                        text: "SoundTouch (LGPL 2.1)"
                        font.underline: true
                        wrapMode: Text.WordWrap

                        MouseArea {
                            anchors.fill: parent
                            onClicked: Qt.openUrlExternally("http://www.surina.net/soundtouch/")
                        }
                    }
                }

                Separator { }
            }
        }
    }
}

