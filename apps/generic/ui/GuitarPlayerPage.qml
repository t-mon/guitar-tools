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
                text: qsTr("Guitar")
                elide: Label.ElideRight
                verticalAlignment: Qt.AlignVCenter
                Layout.fillWidth: true
            }

            IconToolButton {
                iconSource: dataDirectory + "/icons/add.svg"
                onClicked: chordSelectionPopup.open()
            }

            IconToolButton {
                iconSource: dataDirectory + "/icons/fretboard.svg"
                onClicked: pageStack.push(Qt.resolvedUrl("FretBoardPage.qml"))
            }
        }
    }

    property int selectedIndex: 0
    property var currentChord: Core.chords.emptyChord()
    property bool editActive: false

    onEditActiveChanged: evaluateMoving()

    Component.onCompleted: selectChord(0)

    ColumnLayout {
        anchors.fill: parent
        anchors.topMargin: 10
        anchors.bottomMargin: 10

        GridView {
            id: chordsGridView
            cellWidth: width / 4 > 50 ? 50 : width / 4
            cellHeight: cellWidth

            Layout.alignment: Qt.AlignHCenter
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.maximumWidth: parent.width - 5

            model: Core.guitarPlayerChords
            delegate: GuitarChordItem { }

            Item {
                id: dragItem
                width: chordsGridView.cellWidth
                height: chordsGridView.cellHeight
                visible: false

                property string chordName

                Rectangle {
                    id: temporaryShape
                    anchors.fill: dragItem
                    anchors.margins: 2
                    z: 1
                    color: app.green
                    radius: height / 4

                    Label {
                        anchors.centerIn: parent
                        text: dragItem.chordName
                    }

                    states: [
                        State {
                            name: "moving"
                            when: dragItem.visible
                            PropertyChanges {
                                target: dragItem
                                x: chordsGridMouseArea.mouseX + chordsGridMouseArea.offsetX
                                y: chordsGridMouseArea.mouseY + chordsGridMouseArea.offsetY
                                z: 10
                            }
                        }
                    ]

                    RotationAnimation {
                        target: temporaryShape
                        running: !editActive
                        loops: 1
                        property: "rotation"
                        to: 0
                        duration: 100
                    }

                    SequentialAnimation {
                        id: movingAnimation
                        running: editActive
                        loops: Animation.Infinite

                        RotationAnimation {
                            target: temporaryShape
                            property: "rotation"
                            to: 3
                            duration: 60
                        }
                        RotationAnimation {
                            target: temporaryShape
                            property: "rotation"
                            to: 0
                            duration: 60
                        }
                        RotationAnimation {
                            target: temporaryShape
                            property: "rotation"
                            to: -3
                            duration: 60
                        }
                        RotationAnimation {
                            target: temporaryShape
                            property: "rotation"
                            to: 0
                            duration: 60
                        }
                    }
                }
            }

            MouseArea {
                id: chordsGridMouseArea
                anchors.fill: parent
                hoverEnabled: true
                preventStealing : true

                property int index: -1
                property var activeItem: null
                property int activeIndex: -1
                property var fullName
                property bool mousePressed: false
                property bool removePressed: false

                property real removeAreaWidth: chordsGridView.cellWidth / 4
                property real offsetX
                property real offsetY

                onRemovePressedChanged: removePressed ? print("removing pressed") : print("not removing")

                onClicked: {
                    if (index == -1) {
                        editActive = false
                        return
                    }

                    editActive = false
                }

                onPressed: {
                    mousePressed = true
                    index = chordsGridView.indexAt(mouseX, mouseY)
                    if (index == -1)
                        return

                    selectChord(index)

                    activeItem = chordsGridView.itemAt(mouseX, mouseY)
                    activeIndex = index
                    temporaryShape.x = activeItem.x
                    temporaryShape.y = activeItem.y
                    offsetX = activeItem.x - mouseX
                    offsetY = activeItem.y - mouseY
                    chordsGridMouseArea.fullName = currentChord ? currentChord.fullName : ""

                    removePressed = Math.abs(offsetX) < removeAreaWidth && Math.abs(offsetY) < removeAreaWidth

                    if (removePressed && editActive) {
                        editActive = false
                        Core.guitarPlayerChords.removeChord(Core.guitarPlayerChords.get(index))
                        if (index >= Core.guitarPlayerChords.count()) {
                            selectChord(Core.guitarPlayerChords.count() -1)
                        } else {
                            selectChord(index)
                        }
                        return
                    }

                    evaluateMoving()
                }

                onReleased: {
                    mousePressed = false
                    removePressed = false
                    fullName = ""
                    evaluateMoving()
                }

                onPressAndHold: {
                    if (editActive || index == -1)
                        return

                    editActive = true
                }

                onPositionChanged: {
                    if (mousePressed)
                        index = chordsGridView.indexAt(mouseX, mouseY)

                    if (editActive && mousePressed && !removePressed && fullName !== "" && index != -1 && index != activeIndex) {
                        root.selectedIndex = chordsGridView.indexAt(mouseX, mouseY)
                        chordsGridView.model.move(activeIndex, index)
                        activeIndex = index
                    }
                }
            }

            add: Transition {
                NumberAnimation { property: "opacity"; from: 0; to: 1.0; duration: 500 }
                NumberAnimation { property: "scale"; easing.type: Easing.OutBounce; from: 0; to: 1.0; duration: 800 }
            }

            addDisplaced: Transition {
                NumberAnimation { properties: "x,y"; duration: 250; easing.type: Easing.InBack }
            }

            moveDisplaced: Transition {
                NumberAnimation { properties: "x,y"; duration: 250; easing.type: Easing.Linear }
            }

            remove: Transition {
                NumberAnimation { property: "opacity"; to: 1.0; duration: 500 }
                NumberAnimation { property: "width"; to: 0; duration: 250 }
                NumberAnimation { property: "height"; to: 0; duration: 250 }
            }

            removeDisplaced: Transition {
                NumberAnimation { properties: "x,y"; duration: 500; easing.type: Easing.OutBack }
            }
        }

        Item {
            id: guitarItem

            Layout.preferredHeight: stringColumn.height + 2 * offset
            Layout.fillWidth: true

            property real stringAreaHeight: 20
            property real offset: 10

            //Rectangle { anchors.fill: parent; color: "steelblue" ; opacity: .2 }

            Column {
                id: stringColumn
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter

                GuitarStringItem {
                    id: e4String
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: guitarItem.stringAreaHeight
                    noteName: guitarStringToString(Music.GuitarStringE4);
                    thickness: 1.2
                    Component.onCompleted: source = dataDirectory + "/sounds/guitar/E4-0.wav"
                }

                GuitarStringItem {
                    id: bString
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: guitarItem.stringAreaHeight
                    noteName: guitarStringToString(Music.GuitarStringB);
                    thickness: 1.22
                    Component.onCompleted: source = dataDirectory + "/sounds/guitar/B-0.wav"
                }

                GuitarStringItem {
                    id: gString
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: guitarItem.stringAreaHeight
                    noteName: guitarStringToString(Music.GuitarStringG);
                    thickness: 1.24
                    Component.onCompleted: source = dataDirectory + "/sounds/guitar/G-0.wav"
                }

                GuitarStringItem {
                    id: dString
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: guitarItem.stringAreaHeight
                    noteName: guitarStringToString(Music.GuitarStringD);
                    thickness: 1.26
                    Component.onCompleted: source = dataDirectory + "/sounds/guitar/D-0.wav"
                }

                GuitarStringItem {
                    id: aString
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: guitarItem.stringAreaHeight
                    noteName: guitarStringToString(Music.GuitarStringA);
                    thickness: 1.3
                    Component.onCompleted: source = dataDirectory + "/sounds/guitar/A-0.wav"
                }

                GuitarStringItem {
                    id: e2String
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: guitarItem.stringAreaHeight
                    noteName: guitarStringToString(Music.GuitarStringE2);
                    thickness: 1.33
                    Component.onCompleted: source = dataDirectory + "/sounds/guitar/E2-0.wav"
                }
            }

            function calculateCurrentString() {
                if (guitarMouseArea.mouseY >= 0 && guitarMouseArea.mouseY < stringAreaHeight + offset) {
                    if (guitarMouseArea.currentGuitarString != e4String) {
                        guitarMouseArea.currentGuitarString = e4String
                    }
                } else if(guitarMouseArea.mouseY >= bString.y && guitarMouseArea.mouseY < 2 * stringAreaHeight + offset) {
                    if (guitarMouseArea.currentGuitarString != bString) {
                        guitarMouseArea.currentGuitarString = bString
                    }
                } else if(guitarMouseArea.mouseY >= gString.y && guitarMouseArea.mouseY < 3 * stringAreaHeight + offset) {
                    if (guitarMouseArea.currentGuitarString != gString) {
                        guitarMouseArea.currentGuitarString = gString
                    }
                } else if(guitarMouseArea.mouseY >= dString.y && guitarMouseArea.mouseY < 4 * stringAreaHeight + offset) {
                    if (guitarMouseArea.currentGuitarString != dString) {
                        guitarMouseArea.currentGuitarString = dString
                    }
                } else if(guitarMouseArea.mouseY >= aString.y && guitarMouseArea.mouseY < 5 * stringAreaHeight + offset) {
                    if (guitarMouseArea.currentGuitarString != aString) {
                        guitarMouseArea.currentGuitarString = aString
                    }
                } else if(guitarMouseArea.mouseY >= e2String.y && guitarMouseArea.mouseY < 6 * stringAreaHeight + 2 * offset) {
                    if (guitarMouseArea.currentGuitarString != e2String) {
                        guitarMouseArea.currentGuitarString = e2String
                    }
                } else {
                    guitarMouseArea.currentGuitarString = null
                }
            }

            MouseArea {
                id: guitarMouseArea
                anchors.fill: parent
                hoverEnabled: true
                preventStealing : true

                property GuitarStringItem currentGuitarString: null
                property bool mousePressed: false

                onCurrentGuitarStringChanged: {
                    if (currentGuitarString != null) {
                        console.log("CurrentString changed: " + currentGuitarString.noteName)
                        currentGuitarString.pluck()
                    }
                }

                onPressed: {
                    guitarItem.calculateCurrentString()
                    mousePressed = true

                    if (editActive)
                        editActive = false
                }

                onReleased: {
                    currentGuitarString = null
                    mousePressed = false
                }

                onPositionChanged: {
                    if (mousePressed)
                        guitarItem.calculateCurrentString()
                }
            }
        }
    }

    function selectChord(currentIndex) {
        root.selectedIndex = currentIndex
        currentChord = Core.guitarPlayerChords.get(currentIndex)
        chordsGridMouseArea.fullName = currentChord ? currentChord.fullName : ""
        loadChord()
    }

    function evaluateMoving() {
        if (chordsGridMouseArea.mousePressed && editActive && !chordsGridMouseArea.removePressed && chordsGridMouseArea.index != -1) {
            console.log("Start moving item")
            dragItem.chordName = noteToString(currentChord.note) + currentChord.name
            dragItem.visible = true
        } else if (!chordsGridMouseArea.mousePressed && editActive && !chordsGridMouseArea.removePressed) {
            console.log("Stop moving item")
            dragItem.visible = false
        }
    }


    function loadChord() {
        console.log("load chord " + noteToString(currentChord.note) + currentChord.name)

        // E4
        var chordPosition = currentChord.positions.get(Music.GuitarStringE4)
        e4String.source = dataDirectory + "/sounds/guitar/" + Core.getNoteFileName(Music.GuitarStringE4, chordPosition.fret)
        e4String.fret = chordPosition.fret

        // A
        chordPosition = currentChord.positions.get(Music.GuitarStringA)
        aString.source = dataDirectory + "/sounds/guitar/" + Core.getNoteFileName(Music.GuitarStringA, chordPosition.fret)
        aString.fret = chordPosition.fret

        // D
        chordPosition = currentChord.positions.get(Music.GuitarStringD)
        dString.source = dataDirectory + "/sounds/guitar/" + Core.getNoteFileName(Music.GuitarStringD, chordPosition.fret)
        dString.fret = chordPosition.fret

        // G
        chordPosition = currentChord.positions.get(Music.GuitarStringG)
        gString.source = dataDirectory + "/sounds/guitar/" + Core.getNoteFileName(Music.GuitarStringG, chordPosition.fret)
        gString.fret = chordPosition.fret

        // B
        chordPosition = currentChord.positions.get(Music.GuitarStringB)
        bString.source = dataDirectory + "/sounds/guitar/" + Core.getNoteFileName(Music.GuitarStringB, chordPosition.fret)
        bString.fret = chordPosition.fret

        // E2
        chordPosition = currentChord.positions.get(Music.GuitarStringE2)
        e2String.source = dataDirectory + "/sounds/guitar/" + Core.getNoteFileName(Music.GuitarStringE2, chordPosition.fret)
        e2String.fret = chordPosition.fret
    }

    Popup {
        id: chordSelectionPopup
        leftMargin: root.width * 0.2 / 2
        topMargin: root.height * 0.2 / 2
        width: root.width * 0.8
        height: root.height * 0.8
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent

        property var chord: Core.chords.getChord(notePicker.model[notePicker.currentIndex], namePicker.model[namePicker.currentIndex])

        ChordPlayer {
            id: chordPlayer
            chord: chordSelectionPopup.chord
        }

        contentItem: ColumnLayout {

            Row {
                anchors.left: parent.left
                anchors.right: parent.right
                Layout.fillHeight: true

                ListView {
                    id: notePicker
                    anchors.left: parent.left
                    height: parent.height
                    width: parent.width / 2
                    model: [Music.NoteC, Music.NoteCSharp, Music.NoteD, Music.NoteDSharp, Music.NoteE, Music.NoteF, Music.NoteFSharp, Music.NoteG, Music.NoteGSharp, Music.NoteA, Music.NoteASharp, Music.NoteB]
                    focus: true
                    clip: true
                    currentIndex: 0
                    highlightFollowsCurrentItem: true
                    highlight: Rectangle { color: Material.primary; radius: 5 }
                    snapMode: ListView.SnapOneItem
                    delegate: Item {
                        width: parent.width
                        height: 30
                        Label {
                            anchors.centerIn: parent
                            text: app.noteToString(modelData)
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: notePicker.currentIndex = index
                        }
                    }
                }

                ListView {
                    id: namePicker
                    anchors.right: parent.right
                    height: parent.height
                    width: parent.width / 2
                    model: Core.chords.getNames(notePicker.model[notePicker.currentIndex])
                    highlight: Rectangle { color: Material.primary; radius: 5 }
                    focus: true
                    clip: true
                    currentIndex: 0
                    snapMode: ListView.SnapOneItem
                    highlightFollowsCurrentItem: true

                    delegate: Item {
                        width: parent.width
                        height: 30
                        Label {
                            anchors.centerIn: parent
                            text:  {
                                if (modelData === "") {
                                    return app.keyToString(Music.NoteKeyMajor)
                                } else if (modelData === "m") {
                                    return app.keyToString(Music.NoteKeyMinor)
                                } else {
                                    return modelData
                                }
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: namePicker.currentIndex = index
                        }
                    }
                }

            }

            Button {
                Layout.fillWidth: true

                // TRANSLATORS: Play button in the chord selection popover (guitar)
                text: qsTr("Play")
                //color: Material.primary
                onClicked: {
                    console.log("Listen chord: " +  app.noteToString(chordPlayer.chord.note) + chordPlayer.chord.name)
                    chordPlayer.playChord()
                }
            }

            Separator { }

            Button {
                Layout.fillWidth: true

                // TRANSLATORS: Add button in the chord selection popover (guitar)
                text: qsTr("Add")
                //color: UbuntuColors.green
                onClicked: {
                    console.log("Add chord: " +  app.noteToString(chordSelectionPopup.chord.note) + chordSelectionPopup.chord.name)
                    Core.guitarPlayerChords.addChord(chordSelectionPopup.chord)
                    chordSelectionPopup.close()
                }
            }

            Button {
                Layout.fillWidth: true

                // TRANSLATORS: Close button in the chord selection popover (guitar)
                text: qsTr("Close")
                onClicked: chordSelectionPopup.close()
            }
        }
    }



    //    Component {
    //        id: chordSelectionComponent

    //        Dialog {
    //            id: chordSelectionDialog
    //            // TRANSLATORS: Title of the chord selection popover (guitar)
    //            title: qsTr("Select chord")

    //            property var chord: Core.chords.getChord(notePicker.model[notePicker.selectedIndex], namePicker.model[namePicker.selectedIndex])

    //            ChordPlayer {
    //                id: chordPlayer
    //                chord: chordSelectionDialog.chord
    //            }

    //            Connections {
    //                target: chordPlayer
    //                onStringPlucked: indicatorRepeater.itemAt(stringNumber).pluck()
    //            }

    //            Row {
    //                spacing: units.gu(0)

    //                Picker {
    //                    id: notePicker
    //                    width: parent.width / 2
    //                    model: [Music.NoteC, Music.NoteCSharp, Music.NoteD, Music.NoteDSharp, Music.NoteE, Music.NoteF, Music.NoteFSharp, Music.NoteG, Music.NoteGSharp, Music.NoteA, Music.NoteASharp, Music.NoteB]
    //                    circular: false
    //                    delegate: PickerDelegate {
    //                        Label {
    //                            anchors.centerIn: parent
    //                            text: app.noteToString(modelData)
    //                        }
    //                    }
    //                }

    //                Picker {
    //                    id: namePicker
    //                    width: parent.width / 2
    //                    model: Core.chords.getNames(notePicker.model[notePicker.selectedIndex])
    //                    circular: false
    //                    delegate: PickerDelegate {
    //                        Label {
    //                            anchors.centerIn: parent
    //                            text:  {
    //                                if (modelData === "") {
    //                                    return app.keyToString(Music.NoteKeyMajor)
    //                                } else if (modelData === "m") {
    //                                    return app.keyToString(Music.NoteKeyMinor)
    //                                } else {
    //                                    return modelData
    //                                }
    //                            }
    //                        }
    //                    }
    //                }
    //            }

    //            ThinDivider { }

    //            Row {
    //                id: indicatorRow
    //                anchors.left: parent.left
    //                anchors.right: parent.right

    //                Repeater {
    //                    id: indicatorRepeater
    //                    model: 6
    //                    delegate: Item {
    //                        width: parent.width / 6
    //                        height: width

    //                        function pluck() {
    //                            pluckAnimation.restart()
    //                        }

    //                        Rectangle {
    //                            id: indicator
    //                            anchors.centerIn: parent
    //                            width: parent.width * 0.8
    //                            height: width
    //                            radius: width / 2
    //                            border.width: radius / 4
    //                            border.color: chord.positions.get(index).fret < 0 ? UbuntuColors.red : UbuntuColors.green
    //                            color: theme.palette.normal.base

    //                            ColorAnimation {
    //                                id: pluckAnimation
    //                                target: indicator
    //                                property: "color"
    //                                from: UbuntuColors.green
    //                                to: theme.palette.normal.base
    //                                easing.type: Easing.InQuad
    //                                duration: 1000
    //                            }
    //                        }
    //                    }
    //                }
    //            }

    //            Button  {
    //                // TRANSLATORS: Play button in the chord selection popover (guitar)
    //                text: qsTr("Play")
    //                color: UbuntuColors.blue
    //                onClicked: {
    //                    console.log("Listen chord: " +  app.noteToString(chordPlayer.chord.note) + chordPlayer.chord.name)
    //                    chordPlayer.playChord()
    //                }
    //            }

    //            ThinDivider { }

    //            Button  {
    //                // TRANSLATORS: Add button in the chord selection popover (guitar)
    //                text: qsTr("Add")
    //                color: UbuntuColors.green
    //                onClicked: {
    //                    console.log("Add chord: " +  app.noteToString(chordSelectionDialog.chord.note) + chordSelectionDialog.chord.name)
    //                    Core.guitarPlayerChords.addChord(chordSelectionDialog.chord)
    //                    PopupUtils.close(chordSelectionDialog)
    //                }
    //            }

    //            Button {
    //                // TRANSLATORS: Close button in the chord selection popover (guitar)
    //                text: qsTr("Close")
    //                onClicked: PopupUtils.close(chordSelectionDialog)
    //            }
    //        }
    //    }

    //    GuitarBottomEdge { id: bottomEdge }

}


