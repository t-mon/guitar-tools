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
                text: qsTr("Select note")
                elide: Label.ElideRight
                verticalAlignment: Qt.AlignVCenter
                Layout.fillWidth: true
            }
        }
    }


    property int selectionIndex: -1

    Button {
        id: modeButton
        anchors.top: parent.top
        //anchors.topMargin: root.header.implicitHeight
        anchors.left: parent.left
        anchors.right: parent.right
        text: scale.selectMode ? qsTr("Play mode") : qsTr("Select mode")
        highlighted: !scale.selectMode
        onClicked: scale.selectMode = !scale.selectMode
    }


    ScaleItem {
        id: scale
        anchors.top: modeButton.bottom
        anchors.topMargin: 10
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        scale: Core.fretBoardScale
        displayNotes: bottomEdge.displayFretboardNotes
        currentIndex: selectionIndex
        colorfull: true
        selectMode: true
        onSelected: pageStack.pop()
        clip: true
    }


//    ColumnLayout {
//        id: column
//        anchors.left: parent.left
//        anchors.right: parent.right
//        anchors.top: modeButton.bottom

////        Item {
////            Layout.fillWidth: true
////            Layout.maximumWidth: units.gu(50)
////            Layout.preferredHeight: units.gu(7)
////            Layout.alignment: Qt.AlignHCenter

////            Button {
////                id: modeButton
////                anchors.fill: parent
////                anchors.margins: units.gu(1)
////                // TRANSLATORS: Button in the note selection page of the compose tool (play mode -> click on note plays note, select mode -> click on note selects note)
////                text: scale.selectMode ? qsTr("Play mode") : qsTr("Select mode")
////                color: scale.selectMode ? UbuntuColors.green : UbuntuColors.graphite
////                Behavior on color { ColorAnimation { duration: 400 ; easing.type: scale.selectMode ? Easing.OutQuad : Easing.InQuad} }
////                onClicked: scale.selectMode = !scale.selectMode
////            }
////        }

//        Item {
//            Layout.fillWidth: true
//            Layout.fillHeight: true

//            ScaleItem {
//                id: scale
//                anchors.fill: parent
//                scale: Core.fretBoardScale
//                displayNotes: bottomEdge.displayFretboardNotes
//                currentIndex: selectionIndex
//                colorfull: true
//                selectMode: true
//                onSelected: pageLayout.removePages(root)
//            }

//            Component.onCompleted: scale.flickable.clip = true
//        }
//    }

    FretBoardBottomEdge { id: bottomEdge }
}
