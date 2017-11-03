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
import "components"

Page {
    id: root
    header: PageHeader {
        id: pageHeader
        // TRANSLATORS: Title of the load song page
        title: loadExamples ? qsTr("Load example") : qsTr("Load song")
        flickable: songsListView
        trailingActionBar.actions: [
            Action {
                iconName: "info"
                onTriggered: pageLayout.addPageToNextColumn(root, Qt.resolvedUrl("AboutPage.qml"))
            }
        ]
    }

    property var songsModel
    property bool loadExamples: false

    ListView {
        id: songsListView
        anchors.fill: parent
        model: songsModel
        delegate: ListItem {
            id: songItem
            ListItemLayout { title.text: modelData }
            onClicked: {
                if (!loadExamples) {
                    Core.composeTool.load(modelData)
                    pageLayout.removePages(root)
                } else {
                    Core.composeTool.loadExample(modelData)
                    pageLayout.removePages(root)
                }
            }
        }
    }
}
