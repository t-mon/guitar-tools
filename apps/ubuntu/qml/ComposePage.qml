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
import "components"

Page {
    id: root
    header: PageHeader {
        id: pageHeader
        title: Core.composeTool.songName
        trailingActionBar.actions: [
            Action {
                iconName: "navigation-menu"
                onTriggered: PopupUtils.open(menuComponent)
            },
            Action {
                iconName: "info"
                onTriggered: pageLayout.addPageToNextColumn(root, Qt.resolvedUrl("AboutPage.qml"))
            }
        ]
    }

    // Sizes
    property real stepWidth: units.gu(4) + units.gu(4) * Core.composeTool.scaleValue
    property real trackHeight: units.gu(8)
    property real backgroundWidth: Core.composeTool.measureCount * Core.composeTool.rythmTicks * stepWidth
    property real backgroundHeight: Core.composeTool.trackCount * trackHeight
    property real gridCellWidth: backgroundWidth / stepWidth
    property real gridCellHeight: backgroundHeight / Core.composeTool.trackCount
    property real markerCenterOffset: mainItem.width / 2
    property real removeRectangleWidth: units.gu(3)

    // Marker position properties
    property bool markerVisible: true
    property bool markerLeftFromCenter: false
    property bool markerRightFromCenter: false

    // Grid
    property int selectedIndex: 0
    property var currentChord: Core.chords.emptyChord()
    property bool editActive: false

    Connections {
        target: Core.composeTool
        onPlayingChanged: moveMarkInView()
        onScaleValueChanged: moveMarkInView()
        onCurrentTimeStringChanged: moveMarkInView()
        onSongLoaded:  {
            composeScale.update()
            scaleGrid.update()
            moveMarkInView()
        }
    }

    Component.onCompleted: flickable.contentX = 0 && repaintGrid()

    // Check where the marker (visible, right or left from visible center)
    function evaluateMarkerPosition() {
        if (playMark.x < flickable.contentX) {
            // Not visible (left from the screen)
            markerVisible = false
            markerLeftFromCenter = true
            markerRightFromCenter = false
        } else  if (playMark.x > flickable.contentX + mainItem.width) {
            // Not visible (right from the screen)
            markerVisible = false
            markerLeftFromCenter = false
            markerRightFromCenter = true
        } else {
            markerVisible = true

            // if left position from the center
            if (playMark.x > flickable.contentX && playMark.x < flickable.contentX + markerCenterOffset) {
                markerLeftFromCenter = true
                markerRightFromCenter = false
            }

            // if right position from center
            if (playMark.x >= flickable.contentX + markerCenterOffset && playMark.x < flickable.contentX + mainItem.width) {
                markerLeftFromCenter = false
                markerRightFromCenter = true
            }
        }
    }

    function moveMarkInView() {
        evaluateMarkerPosition()

        // Move view to visible area
        if (Core.composeTool.playing && !markerVisible) {
            // fade in
            if (playMark.x < markerCenterOffset) {
                flickable.contentX = 0
                return
            }
            // fade out
            if (playMark.x > flickable.contentWidth - mainItem.width) {
                flickable.contentX = flickable.contentWidth - mainItem.width
                return
            }
            // Move the view to current mark
            flickable.contentX = playMark.x - stepWidth
        }
    }


    ColumnLayout {
        id: mainGridLayout
        anchors.fill: parent
        anchors.topMargin: pageHeader.height
        anchors.bottomMargin: units.gu(3)

        spacing: 0

        Rectangle {
            id: infoBar
            Layout.fillWidth: true
            Layout.preferredHeight: units.gu(3)
            color: theme.palette.normal.base

            RowLayout {
                anchors.fill: parent

                Item {
                    Layout.fillWidth: true
                    height: parent.height

                    Rectangle { anchors.fill: parent; color: "blue" ; opacity: .2 }

                    Label {
                        anchors.centerIn: parent
                        text: Core.composeTool.currentTimeString
                    }
                }

                Item {
                    Layout.fillWidth: true
                    height: parent.height

                    Rectangle { anchors.fill: parent; color: "red" ; opacity: .2 }

                    Label {
                        anchors.centerIn: parent
                        text: "bpm: " + Core.composeTool.bpm
                    }
                }

                Item {
                    Layout.fillWidth: true
                    height: parent.height
                    Rectangle { anchors.fill: parent; color: "green" ; opacity: .2 }

                    Label {
                        anchors.centerIn: parent
                        text: Core.composeTool.rythmTicks + "/4"
                    }
                }
            }
        }


        Flickable {
            id: scaleFlickable
            Layout.fillWidth: true
            Layout.preferredHeight: contentHeight
            contentHeight: units.gu(6)
            clip: true
            contentWidth: composeItem.width
            flickableDirection: Flickable.HorizontalFlick
            interactive: !Core.composeTool.playing

            onContentXChanged: if(moving) flickable.contentX = contentX

            Column {
                anchors.fill: parent
                Item {
                    id: scaleItem
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.leftMargin: units.gu(2)
                    anchors.rightMargin: units.gu(2)
                    height: units.gu(4)

                    Repeater {
                        anchors.left: parent.left
                        anchors.top: parent.top
                        model: Core.composeTool.columnCount / Core.composeTool.rythmTicks
                        delegate: Label {
                            x: index * stepWidth * Core.composeTool.rythmTicks - width / 2
                            text: index
                        }
                    }

                    ComposeScale {
                        id: composeScale
                        anchors.fill: parent
                        color: theme.palette.normal.baseText
                        textColor: theme.palette.normal.foregroundText
                        measureCount: Core.composeTool.measureCount
                        rythmTicks: Core.composeTool.rythmTicks
                        trackCount: Core.composeTool.trackCount
                        Component.onCompleted: update()
                    }
                }

                Rectangle {
                    id: playMarkArea
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.leftMargin: units.gu(2)
                    anchors.rightMargin: units.gu(2)
                    color: "red"
                    opacity: 0.3
                    height: units.gu(2)
                    radius: units.gu(0.5)

                    MouseArea {
                        id: playMarkMouseArea
                        anchors.fill: parent
                        preventStealing: !Core.composeTool.playing
                        onPressed: {
                            if (!Core.composeTool.playing) {
                                var currentTime = Core.composeTool.duration * mouseX / parent.width
                                Core.composeTool.setCurrentTime(currentTime)
                            }
                        }
                    }
                }
            }
        }

        Item {
            id: mainItem
            Layout.fillHeight: true
            Layout.fillWidth: true

            Flickable {
                id: flickable
                anchors.fill: parent
                clip: true
                contentHeight: composeItem.height
                contentWidth: composeItem.width
                flickableDirection: Flickable.HorizontalAndVerticalFlick
                interactive: !Core.composeTool.playing

                onContentXChanged: {
                    if (moving) scaleFlickable.contentX = contentX
                    if (Core.composeTool.playing) scaleFlickable.contentX = contentX
                    evaluateMarkerPosition()
                }

                Item {
                    id: composeItem
                    width: backgroundWidth + units.gu(4)
                    height: backgroundHeight

                    Rectangle {
                        id: backgroundShape
                        anchors.fill: parent
                        anchors.leftMargin: units.gu(2)
                        anchors.rightMargin: units.gu(2)
                        border.color: theme.palette.normal.baseText
                        border.width: units.gu(0.1)
                        color: theme.palette.normal.base
                        radius: units.gu(1)

                        ComposeGrid {
                            id: scaleGrid
                            anchors.fill: parent
                            color: theme.palette.normal.baseText
                            measureCount: Core.composeTool.measureCount
                            rythmTicks: Core.composeTool.rythmTicks
                            trackCount: Core.composeTool.trackCount
                            Component.onCompleted: update()
                        }

                        Repeater {
                            id: noteRepeater
                            anchors.fill: parent
                            model: Core.composeTool.notes

                            function removeNoteItem() {
                                for (var i = 0; i < count; i++) {
                                    if (noteRepeater.itemAt(i).coordinate === gridMouseArea.currentComposeNote.coordinate) {
                                        noteRepeater.itemAt(i).removeAnimation.start()
                                    }
                                }
                            }

                            delegate: UbuntuShape {
                                id: noteShape
                                width: gridView.cellWidth
                                height: gridView.cellHeight
                                property var noteColor: Core.getColorForNote(model.source)

                                radius: "large"
                                color: noteColor
                                opacity: 0
                                visible: {
                                    if (!editActive)
                                        return true

                                    if (!gridMouseArea.currentComposeNote || !gridMouseArea.mousePressed)
                                        return true

                                    if (gridMouseArea.mousePressed && model.coordinate === gridMouseArea.currentComposeNote.coordinate)
                                        return false

                                    return true
                                }

                                UbuntuShape {
                                    id: innerNoteRectangle
                                    anchors.fill: parent
                                    anchors.margins: units.gu(0.8)
                                    opacity: 0.5
                                    color: theme.palette.normal.base
                                    radius: "large"
                                }

                                ParallelAnimation {
                                    id: pluckAnimation

                                    ColorAnimation {
                                        target: innerNoteRectangle
                                        property: "color"
                                        from: noteColor
                                        to: theme.palette.normal.base
                                        easing.type: Easing.InQuad
                                        duration: 1000
                                    }

                                    PropertyAnimation {
                                        target: innerNoteRectangle
                                        property: "opacity"
                                        duration: 500
                                        from: 1
                                        to: 0.5
                                        easing.type: Easing.OutQuad
                                    }

                                    PropertyAnimation {
                                        target: noteShape
                                        property: "scale"
                                        duration: 500
                                        from: 1.05
                                        to: 1
                                        easing.type: Easing.OutBounce
                                    }
                                }


                                x: model.coordinate.x *gridView.cellWidth
                                y: model.coordinate.y * gridView.cellHeight

                                Behavior on x { NumberAnimation { duration: 250; easing.type: Easing.OutBack } }
                                Behavior on y { NumberAnimation { duration: 250; easing.type: Easing.OutBack } }

                                UbuntuShape {
                                    id: removeShape
                                    color: UbuntuColors.lightGrey
                                    anchors.left: noteShape.left
                                    anchors.top: noteShape.top
                                    width: removeRectangleWidth
                                    height: width
                                    radius: "large"
                                    z: 2
                                    backgroundColor: "#CCff4444"
                                    opacity: editActive ? 1 : 0

                                    Icon {
                                        anchors.centerIn: parent
                                        implicitHeight: parent.height * 0.7
                                        implicitWidth: parent.width * 0.7
                                        name: "delete"
                                    }

                                    Behavior on opacity { NumberAnimation { duration: 250 } }
                                }

                                Connections {
                                    target: Core.composeTool.notes.get(model.coordinate)
                                    onPlucked: pluckAnimation.restart()
                                    onRemoved: removeAnimation.start()
                                }

                                Label {
                                    id: noteLable
                                    anchors.centerIn: parent
                                    opacity: Core.settings.displayFretboardNotes && width < innerNoteRectangle.width ? 1 : 0
                                    Behavior on opacity { NumberAnimation { duration: 400 } }
                                    text: app.noteToString(model.note)
                                }

                                RotationAnimation {
                                    target: noteShape
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
                                        target: noteShape
                                        property: "rotation"
                                        to: 3
                                        duration: 60
                                    }
                                    RotationAnimation {
                                        target: noteShape
                                        property: "rotation"
                                        to: 0
                                        duration: 60
                                    }
                                    RotationAnimation {
                                        target: noteShape
                                        property: "rotation"
                                        to: -3
                                        duration: 60
                                    }
                                    RotationAnimation {
                                        target: noteShape
                                        property: "rotation"
                                        to: 0
                                        duration: 60
                                    }
                                }

                                ParallelAnimation {
                                    id: createAnimation
                                    NumberAnimation { target: noteShape; property: "opacity"; from: 0; to: 1.0; duration: 500 }
                                    NumberAnimation { target: noteShape; property: "scale"; easing.type: Easing.OutBounce; from: 0; to: 1.0; duration: 800 }
                                }

                                ParallelAnimation {
                                    id: removeAnimation
                                    NumberAnimation { target: noteShape; property: "opacity"; to: 0; duration: 500 }
                                    NumberAnimation { target: noteShape; property: "width"; to: 0; duration: 300 }
                                    NumberAnimation { target: noteShape; property: "height"; to: 0; duration: 300 }

                                    onRunningChanged: {
                                        running ? print("Remove animation running") : print("Remove animation stopped running")
                                        if (!running) {
                                            Core.composeTool.removeNote(gridMouseArea.removeIndex)
                                        } else {
                                            noteLable.opacity = 0
                                        }
                                    }
                                }

                                Component.onCompleted: createAnimation.start()
                            }
                        }

                        GridView {
                            id: gridView
                            anchors.fill: parent
                            cellWidth: stepWidth
                            cellHeight: trackHeight

                            model: Core.composeTool.rowCount * Core.composeTool.columnCount

                            delegate: Item {
                                id: gridItem
                                width: gridCellWidth
                                height: gridCellHeight
                            }

                            UbuntuShape {
                                id: movingNoteShape
                                width: gridView.cellWidth
                                height: gridView.cellHeight
                                z: 2
                                radius: "large"
                                color: UbuntuColors.blue
                                visible: false

                                UbuntuShape {
                                    id: movingiInnerNoteRectangle
                                    anchors.fill: parent
                                    anchors.margins: units.gu(0.8)
                                    opacity: 0.5
                                    color: theme.palette.normal.base
                                    radius: "large"
                                }

                                Label {
                                    id: movingRectangleLabel
                                    anchors.centerIn: parent
                                    opacity: Core.settings.displayFretboardNotes && width < movingiInnerNoteRectangle.width ? 1 : 0
                                    Behavior on opacity { NumberAnimation { duration: 500 } }
                                }

                                RotationAnimation {
                                    target: movingNoteShape
                                    running: !editActive && movingNoteShape.visible
                                    loops: 1
                                    property: "rotation"
                                    to: 0
                                    duration: 100
                                }

                                SequentialAnimation {
                                    id: moveAnimation
                                    running: editActive && movingNoteShape.visible
                                    loops: Animation.Infinite

                                    RotationAnimation {
                                        target: movingNoteShape
                                        property: "rotation"
                                        to: 3
                                        duration: 60
                                    }
                                    RotationAnimation {
                                        target: movingNoteShape
                                        property: "rotation"
                                        to: 0
                                        duration: 60
                                    }
                                    RotationAnimation {
                                        target: movingNoteShape
                                        property: "rotation"
                                        to: -3
                                        duration: 60
                                    }
                                    RotationAnimation {
                                        target: movingNoteShape
                                        property: "rotation"
                                        to: 0
                                        duration: 60
                                    }
                                }

                                states: [
                                    State {
                                        name: "moving"
                                        when: movingNoteShape.visible
                                        PropertyChanges {
                                            target: movingNoteShape
                                            x: gridMouseArea.mouseX + gridMouseArea.offsetX
                                            y: gridMouseArea.mouseY + gridMouseArea.offsetY
                                            z: 10
                                        }
                                    }
                                ]
                            }

                            MouseArea {
                                id: gridMouseArea
                                anchors.fill: parent
                                hoverEnabled: true
                                preventStealing: true

                                property int currentIndex: gridView.indexAt(mouseX, mouseY)
                                property int pressedIndex: -1
                                property int movedIndex: -1
                                property bool mousePressed: false
                                property bool removePressed: false
                                property int removeIndex: -1

                                property QtObject currentComposeNote

                                property real offsetX
                                property real offsetY

                                onRemovePressedChanged: removePressed ? print("removing pressed") : print("not removing")
                                onMousePressedChanged: mousePressed ? print("mouse pressed") : print("mouse released")

                                onClicked: {
                                    if (Core.composeTool.playing) return

                                    if (editActive) {
                                        editActive = false
                                        return
                                    }

                                    if (!Core.composeTool.hasComposeNote(currentIndex)) {
                                        if (editActive) {
                                            editActive = false
                                        } else {
                                            pageLayout.addPageToCurrentColumn(root, Qt.resolvedUrl("ComposeSelectorPage.qml"), { selectionIndex: currentIndex } )
                                        }
                                    } else {
                                        if (!currentComposeNote) return
                                        Core.notePlayer.play("file://" + dataDirectory + "sounds/guitar/" + currentComposeNote.source)
                                        currentComposeNote.plucked()
                                    }
                                }

                                onPressed: {
                                    currentIndex = gridView.indexAt(mouseX, mouseY)
                                    if (currentIndex == -1)
                                        return

                                    mousePressed = true
                                    movedIndex = currentIndex

                                    movingNoteShape.x = gridView.itemAt(mouseX, mouseY).x
                                    movingNoteShape.y = gridView.itemAt(mouseX, mouseY).y
                                    offsetX = movingNoteShape.x - mouseX
                                    offsetY = movingNoteShape.y - mouseY

                                    currentComposeNote = Core.composeTool.getComposeNote(movedIndex)
                                    if (!currentComposeNote || !editActive)
                                        return

                                    removePressed = Math.abs(offsetX) < removeRectangleWidth && Math.abs(offsetY) < removeRectangleWidth
                                    if (removePressed) {
                                        removeIndex = currentIndex
                                        currentComposeNote.removed()
                                        return
                                    }

                                    evaluateMoving()
                                }

                                onReleased:  {
                                    mousePressed = false
                                    removePressed = false
                                    pressedIndex = -1
                                    evaluateMoving()
                                }

                                onPressAndHold: {
                                    editActive = true
                                    evaluateMoving()
                                }

                                onCurrentIndexChanged: {
                                    if (Core.composeTool.playing)
                                        return

                                    console.log(currentIndex)
                                }

                                onPositionChanged: {
                                    if (mousePressed)
                                        currentIndex =  gridView.indexAt(mouseX, mouseY)

                                    if (mousePressed && !removePressed && currentIndex != -1 && currentIndex != movedIndex && editActive && !Core.composeTool.hasComposeNote(currentIndex)) {
                                        Core.composeTool.moveNote(movedIndex, currentIndex)
                                        movedIndex = currentIndex
                                    }
                                }
                            }
                        }

                        Rectangle {
                            id: playMark
                            height: backgroundHeight
                            width: units.gu(0.3)
                            color: UbuntuColors.red
                            y: 0
                            x: backgroundShape.width * Core.composeTool.positionPercentage - width / 2
                            z: 20
                            onXChanged: {
                                if (!Core.composeTool.playing)
                                    return

                                // No need for fading
                                if (flickable.contentWidth <= mainItem.width)
                                    return

                                evaluateMarkerPosition()

                                if (flickable.atXEnd) return

                                // Marker visible and left from center
                                if (markerVisible && markerLeftFromCenter) return

                                // Marker at center
                                if (markerVisible && markerRightFromCenter)
                                    flickable.contentX = backgroundShape.width * Core.composeTool.positionPercentage - markerCenterOffset - width / 2

                            }
                        }
                    }
                }
            }

            Scrollbar {
                id: horizontalScollbar
                flickableItem: flickable
                align: Qt.AlignBottom
            }

            Scrollbar {
                id: verticalScollbar
                flickableItem: flickable
                align: Qt.AlignRight
            }
        }

        RowLayout {
            id: toolRowLayout
            Layout.fillWidth: true
            Layout.maximumWidth: parent.width - units.gu(2)
            Layout.alignment: Qt.AlignHCenter

            Button {
                id: playPauseButton
                Layout.fillWidth: true
                color: theme.palette.normal.base
                iconName: Core.composeTool.playing ? "media-playback-pause" : "media-playback-start"
                onClicked: Core.composeTool.togglePlayPause()
            }

            Button {
                id: resetButton
                Layout.fillWidth: true
                iconName: "media-playback-stop"
                color: theme.palette.normal.base
                onClicked: {
                    flickable.contentX = 0
                    Core.composeTool.stop()
                    Core.composeTool.setCurrentTime(0)
                }
            }

            Button {
                id: settingsButton
                Layout.fillWidth: true
                iconName: "camera-self-timer"
                color: Core.composeTool.enableMetronome ? UbuntuColors.green : theme.palette.normal.base
                onClicked: {
                    Core.composeTool.enableMetronome = !Core.composeTool.enableMetronome
                    Core.composeTool.save()
                }
            }

            Button {
                id: metronomeButton
                Layout.fillWidth: true
                color: theme.palette.normal.base
                iconName: "settings"
                onClicked: if (!Core.composeTool.playing) root.pageStack.addPageToCurrentColumn(root, Qt.resolvedUrl("ComposeSettingsPage.qml"))

            }
        }
    }

    function evaluateMoving() {
        if (gridMouseArea.mousePressed && editActive && !gridMouseArea.removePressed && gridMouseArea.movedIndex != -1) {
            console.log("Start moving item")
            movingNoteShape.visible = true
            movingRectangleLabel.text =  app.noteToString(gridMouseArea.currentComposeNote.note)
            movingNoteShape.color = Core.getColorForNote(gridMouseArea.currentComposeNote.source)
        } else if (!gridMouseArea.mousePressed && editActive && !gridMouseArea.removePressed) {
            console.log("Stop moving item")
            movingNoteShape.visible = false
        }
    }

    Component {
        id: menuComponent
        Dialog {
            id: menuDialog
            // TRANSLATORS: Title of the song menu in the compose tool
            title: i18n.tr("Song menu")

            Button {
                id: newSongButton
                // TRANSLATORS: Button in the menu of the compose tool
                text: i18n.tr("New song")
                onClicked: {
                    PopupUtils.close(menuDialog)
                    PopupUtils.open(newSongComponent)
                }
            }


            Button {
                id: saveButton
                // TRANSLATORS: Button in the menu of the compose tool (Save the current song)
                text: i18n.tr("Save")
                onClicked: {
                    PopupUtils.close(menuDialog)
                    Core.composeTool.save()
                }
            }

            Button {
                id: saveAsButton
                // TRANSLATORS: Button in the menu of the compose tool (Save the current song as...)
                text: i18n.tr("Save as")
                onClicked: {
                    PopupUtils.close(menuDialog)
                    PopupUtils.open(saveAsComponent)
                }
            }

            Button {
                id: loadButton
                // TRANSLATORS: Button in the menu of the compose tool (Load a song)
                text: i18n.tr("Load song")
                onClicked: {
                    PopupUtils.close(menuDialog)
                    pageLayout.addPageToNextColumn(root, Qt.resolvedUrl("ComposeLoadPage.qml"), { songsModel: Core.composeTool.songs })
                }
            }

            Button {
                id: loadExampleButton
                // TRANSLATORS: Button in the menu of the compose tool (Load examples)
                text: i18n.tr("Load example")
                onClicked: {
                    PopupUtils.close(menuDialog)
                    pageLayout.addPageToNextColumn(root, Qt.resolvedUrl("ComposeLoadPage.qml"), { songsModel: Core.composeTool.exampleSongs(), loadExamples: true })
                }
            }

            ThinDivider { }

            Button {
                id: renameButton
                // TRANSLATORS: Rename the current song
                text: i18n.tr("Rename song")
                onClicked: {
                    PopupUtils.close(menuDialog)
                    PopupUtils.open(renameComponent)
                }
            }

            Button {
                id: deleteButton
                // TRANSLATORS: Delete the current song
                text: i18n.tr("Delete song")
                onClicked: {
                    PopupUtils.close(menuDialog)
                    PopupUtils.open(removeComponent)
                }
            }

            ThinDivider { }

            Button {
                // TRANSLATORS: Close button in the compose song menu popover
                text: i18n.tr("Close")
                onClicked: PopupUtils.close(menuDialog)
            }
        }
    }

    Component {
        id: newSongComponent
        Dialog {
            id: newSongDialog

            // TRANSLATORS: Title of the new song as dialog
            title: i18n.tr("New song")

            TextField {
                id: songNameTextField
                // TRANSLATORS: Placeholder text for a new song name
                placeholderText: i18n.tr("Song name")
            }

            ThinDivider { }

            Button {
                // TRANSLATORS: Create new song button
                text: i18n.tr("Create")
                color: UbuntuColors.green
                onClicked: {
                    Core.composeTool.newSong(songNameTextField.text);
                    PopupUtils.close(newSongDialog)
                }
            }

            Button {
                text: i18n.tr("Cancel")
                onClicked: PopupUtils.close(newSongDialog)
            }
        }
    }


    Component {
        id: saveAsComponent
        Dialog {
            id: saveAsDialog

            // TRANSLATORS: Title of the save as dialog
            title: i18n.tr("Save as")

            TextField {
                id: songNameTextField
                placeholderText: Core.composeTool.songName
            }

            ThinDivider { }

            Button {
                // TRANSLATORS: Save button in the 'Save as' dialog
                text: i18n.tr("Save")
                color: UbuntuColors.green
                onClicked: {
                    Core.composeTool.saveAs(songNameTextField.text);
                    PopupUtils.close(saveAsDialog)
                }
            }

            Button {
                text: i18n.tr("Cancel")
                onClicked: PopupUtils.close(saveAsDialog)
            }
        }
    }

    Component {
        id: loadComponent
        Dialog {
            id: loadDialog

            // TRANSLATORS: Title of the load song as dialog
            title: i18n.tr("Load song")
            UbuntuListView {
                id: songsListView
                clip: true
                model: Core.composeTool.songs
                width: parent.width
                height: units.gu(20)
                delegate: ListItem {
                    id: songItem
                    ListItemLayout { title.text: modelData }
                    onClicked: {
                        PopupUtils.close(loadDialog)
                        Core.composeTool.load(modelData)
                    }
                }
            }

            ThinDivider { }

            Button {
                text: i18n.tr("Cancel")
                onClicked: PopupUtils.close(loadDialog)
            }

        }
    }

    Component {
        id: renameComponent
        Dialog {
            id: renameDialog

            // TRANSLATORS: Title of the rename song dialog
            title: i18n.tr("Rename song")

            TextField {
                id: songNameTextField
                placeholderText: Core.composeTool.songName
            }

            ThinDivider { }

            Button {
                // TRANSLATORS: Save button in the 'Save as' dialog
                text: i18n.tr("Rename")
                color: UbuntuColors.green
                onClicked: {
                    Core.composeTool.renameSong(songNameTextField.text);
                    PopupUtils.close(renameDialog)
                }
            }

            Button {
                text: i18n.tr("Cancel")
                onClicked: PopupUtils.close(renameDialog)
            }
        }
    }


    Component {
        id: removeComponent
        Dialog {
            id: removeDialog

            // TRANSLATORS: Title of the delete song as dialog
            title: i18n.tr("Delete song")

            // TRANSLATORS: Delete question for the delete song dialog. The place holder represents the song name.
            text: i18n.tr("Are you sure you want to delete \"%1\"?").arg(Core.composeTool.songName)

            Button {
                id: deleteButton
                text: i18n.tr("Delete")
                color: UbuntuColors.red
                onClicked: {
                    PopupUtils.close(removeDialog)
                    Core.composeTool.deleteSong(Core.composeTool.songName)
                }
            }

            ThinDivider { }

            Button {
                text: i18n.tr("Cancel")
                color: UbuntuColors.green
                onClicked: PopupUtils.close(removeDialog)
            }
        }
    }

    ComposeBottomEdge { id: bottomEdge }
}
