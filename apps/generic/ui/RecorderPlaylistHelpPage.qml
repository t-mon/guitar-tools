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
        // TRANSLATORS: Records help page title
        title: qsTr("Help")
        flickable: helpFlickable
        trailingActionBar.actions: [
            Action {
                iconName: "info"
                onTriggered: pageLayout.addPageToCurrentColumn(root, Qt.resolvedUrl("AboutPage.qml"))
            }
        ]
    }

    Flickable {
        id: helpFlickable
        anchors.fill: parent
        contentHeight: helpColumn.height

        Column {
            id: helpColumn
            anchors.left: parent.left
            anchors.leftMargin: units.gu(2)
            anchors.right: parent.right
            anchors.rightMargin: units.gu(2)

            spacing: units.gu(1)

            ThinDivider { }


            Label {
                anchors.left: parent.left
                anchors.right: parent.right
                // TRANSLATORS: Records help page
                text: qsTr("Records location:")
                wrapMode: Text.WordWrap
            }

            Label {
                anchors.left: parent.left
                anchors.right: parent.right
                text: Core.recorder.filePath
                font.underline: true
                wrapMode: Text.WordWrap
            }


            ThinDivider { }

            Row {
                anchors.left: parent.left
                anchors.right: parent.right
                spacing: units.gu(3)

                Icon {
                    id: playIcon
                    name: "media-playback-start"
                    width: units.gu(4)
                    height: width
                    implicitHeight: height
                    implicitWidth: width
                }

                Label {
                    // TRANSLATORS: Records help page: delete icon description
                    text: qsTr("Click to play")
                    anchors.verticalCenter: playIcon.verticalCenter
                }
            }

            ThinDivider { }

            Row {
                anchors.left: parent.left
                anchors.right: parent.right
                spacing: units.gu(3)

                Icon {
                    id: stopIcon
                    name: "media-playback-stop"
                    width: units.gu(4)
                    height: width
                    implicitHeight: height
                    implicitWidth: width
                }

                Label {
                    // TRANSLATORS: Records help page: delete icon description
                    text: qsTr("Click again to stop")
                    anchors.verticalCenter: stopIcon.verticalCenter
                }
            }

            ThinDivider { }

            Row {
                anchors.left: parent.left
                anchors.right: parent.right
                spacing: units.gu(3)
                Icon {
                    id: deleteIcon
                    name: "delete"
                    width: units.gu(4)
                    height: width
                    implicitHeight: height
                    implicitWidth: width
                }

                Label {
                    // TRANSLATORS: Records help page: delete icon description
                    text: qsTr("Delete record")
                    anchors.verticalCenter: deleteIcon.verticalCenter
                }
            }

            ThinDivider { }

            Row {
                anchors.left: parent.left
                anchors.right: parent.right
                spacing: units.gu(3)
                Icon {
                    id: editIcon
                    name: "edit"
                    width: units.gu(4)
                    height: width
                    implicitHeight: height
                    implicitWidth: width
                }

                Label {
                    // TRANSLATORS: Records help page: edit icon description
                    text: qsTr("Rename record")
                    anchors.verticalCenter: editIcon.verticalCenter
                }
            }

            ThinDivider { }

            Row {
                anchors.left: parent.left
                anchors.right: parent.right
                spacing: units.gu(3)
                Icon {
                    id: infoIcon
                    name: "info"
                    width: units.gu(4)
                    height: width
                    implicitHeight: height
                    implicitWidth: width
                }

                Label {
                    // TRANSLATORS: Records help page: edit icon description
                    text: qsTr("Record information")
                    anchors.verticalCenter: infoIcon.verticalCenter
                }
            }

            ThinDivider { }
        }
    }
}
