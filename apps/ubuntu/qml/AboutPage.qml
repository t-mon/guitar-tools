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
import QtQuick.Layouts 1.1
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import Ubuntu.Components.ListItems 1.3
import GuitarTools 1.0

Page {
    id: root
    header: PageHeader {
        id: pageHeader
        title: i18n.tr("About")
        flickable: aboutFlickable
    }

    Flickable {
        id: aboutFlickable
        anchors.fill: parent
        contentHeight: aboutColumn.height

        Column {
            id: aboutColumn
            anchors.left: parent.left
            anchors.leftMargin: units.gu(2)
            anchors.right: parent.right
            anchors.rightMargin: units.gu(2)

            spacing: units.gu(3)

            Column {
                anchors.left: parent.left
                anchors.right: parent.right
                spacing: units.gu(2)

                Item {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: units.gu(7)

                    Label {
                        anchors.centerIn: parent
                        text: "Guitar tools"
                        font.bold: true
                        font.pixelSize: units.gu(5)
                    }
                }


                UbuntuShape {
                    id: iconImage
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: units.gu(10)
                    height: width
                    radius: "medium"
                    source: Image {
                        anchors.fill: parent
                        source: "file://" + dataDirectory + "icons/guitar-tools.svg"
                    }
                }

                Label {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: version
                    font.bold: true
                    font.pixelSize: units.gu(3)
                }

                Label {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "2016 © Simon Stürz"
                }

                ThinDivider { }
            }


            Column {
                anchors.left: parent.left
                anchors.right: parent.right
                spacing: units.gu(1)

                Row {
                    anchors.left: parent.left
                    spacing: units.gu(2)

                    Label {
                        // TRANSLATORS: In the about screen.
                        text: i18n.tr("License:")
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
                    spacing: units.gu(2)

                    Label {
                        // TRANSLATORS: In the about screen.
                        text: i18n.tr("Source code:")
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
                    spacing: units.gu(2)

                    Label {
                        // TRANSLATORS: In the about screen.
                        text: i18n.tr("Bugtracker:")
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
                    spacing: units.gu(2)

                    Label {
                        // TRANSLATORS: Thank you very much for helping with the translations!! :)
                        text: i18n.tr("Translations:")
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
                    spacing: units.gu(2)

                    Label {
                        // TRANSLATORS: In the about screen.
                        text: i18n.tr("Mail:")
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
                    spacing: units.gu(2)

                    Label {
                        // TRANSLATORS: In the about screen.
                        text: i18n.tr("Design:")
                        font.bold: true
                    }

                    Label {
                        text: "Simon Stürz"
                    }
                }

                Row {
                    anchors.left: parent.left
                    spacing: units.gu(2)

                    Label {
                        // TRANSLATORS: In the about screen.
                        text: i18n.tr("Click packaging:")
                        font.bold: true
                    }

                    Label {
                        text: "Jonatan Hatakeyama Zeidler"
                    }
                }

                ThinDivider { }

                Label {
                    // TRANSLATORS: Donate button description
                    text: i18n.tr("Enjoying the app?")
                    font.bold: true
                    wrapMode: Text.WordWrap
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Button {
                    id: donateButton
                    anchors.left: parent.left
                    anchors.leftMargin: units.gu(5)
                    anchors.right: parent.right
                    anchors.rightMargin: units.gu(5)
                    color: "green"
                    // TRANSLATORS: Text in the Donate button
                    text: i18n.tr("Donate (PayPal)")
                    font.underline: true
                    onClicked: Qt.openUrlExternally("https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=C3UKTC3XY9SJ6")
                }

                ThinDivider { }

                Label {
                    id: sounds
                    anchors.left: parent.left
                    anchors.right: parent.right
                    // TRANSLATORS: In the about screen.
                    text: i18n.tr("Thanks to Fabian Baumgartner and Alfred Bushi for recording the guitar sounds with me. We release the sounds under the <b>CC BY-NC 3.0</b>.")
                    wrapMode: Text.WordWrap
                }

                ThinDivider { }

                Row {
                    anchors.left: parent.left
                    anchors.right: parent.right

                    spacing: units.gu(1)

                    Label {
                        id: metronomeTitle
                        // TRANSLATORS: In the about screen.
                        text: i18n.tr("Metronome sounds:")
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

                ThinDivider { }

                Row {
                    anchors.left: parent.left
                    anchors.right: parent.right

                    spacing: units.gu(1)

                    Label {
                        id: drumLoopsTitle
                        // TRANSLATORS: In the about screen.
                        text: i18n.tr("Drum loops:")
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

                ThinDivider { }

                Row {
                    anchors.left: parent.left
                    anchors.right: parent.right

                    spacing: units.gu(1)

                    Label {
                        id: libsTitle
                        // TRANSLATORS: In the about screen.
                        text: i18n.tr("External library:")
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

                ThinDivider { }
            }
        }
    }
}

