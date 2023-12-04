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
import Qt.labs.folderlistmodel 1.0
import QtQuick.Layouts 1.1
import Lomiri.Components 1.3
import Lomiri.Components.Popups 1.3
import Lomiri.Components.ListItems 1.3
import GuitarTools 1.0

Page {
    id: root
    header: PageHeader {
        id: pageHeader
        // TRANSLATORS: Title of the records playlist page
        title: i18n.tr("Records")
        flickable: recordsListView
        trailingActionBar.actions: [
            Action {
                iconName: "info"
                onTriggered: pageLayout.addPageToCurrentColumn(root, Qt.resolvedUrl("AboutPage.qml"))
            },
            Action {
                iconName: "help"
                onTriggered: pageLayout.addPageToCurrentColumn(root, Qt.resolvedUrl("RecorderPlaylistHelpPage.qml"))
            }
        ]
    }

    property string sourceFile: ""
    property string fileName: ""
    property string fileNamePath: ""
    property int index: 0

    Connections {
        target: Qt.application
        onActiveChanged: {
            if (!Qt.application.active)
                player.stop()
        }
    }

    FolderListModel {
        id: folderModel
        folder: "file://" + Core.recorder.filePath
        nameFilters: [ "*.ogg" ]
        sortField: "Time"
    }

    Audio {
        id: player
        volume: Core.settings.guitarPlayerVolume / 100
    }

    ListView {
        id: recordsListView
        anchors.fill: parent
        model: folderModel
        ViewItems.expansionFlags: ViewItems.CollapseOnOutsidePress
        delegate: ListItem {
            id: recordItem
            ListItemLayout {
                id: itemLayout
                title.text: model.fileBaseName
                subtitle.text: Math.round(model.fileSize / 1000) < 1024 ? (model.fileSize / 1000).toFixed(2) + " kB" : (model.fileSize / (1000 * 1024)).toFixed(1) + " MB"

                Icon {
                    name: "media-playback-stop"
                    visible: player.playbackState === Audio.PlayingState && root.fileName === model.fileName
                    SlotsLayout.position: SlotsLayout.Trailing;
                    width: units.gu(3)
                    height: width
                    implicitHeight: height
                    implicitWidth: width
                }
            }

            leadingActions: ListItemActions {
                actions: [
                    Action {
                        iconName: "delete"
                        onTriggered: {
                            root.fileNamePath = Core.recorder.filePath + "/" + model.fileName
                            root.fileName = model.fileName
                            PopupUtils.open(removeComponent)
                        }
                    }
                ]
            }

            trailingActions: ListItemActions {
                actions: [
                    Action {
                        iconName: "edit"
                        onTriggered: {
                            root.fileNamePath = Core.recorder.filePath + "/" + model.fileName
                            root.fileName = model.fileName
                            PopupUtils.open(renameComponent)
                        }
                    },
                    Action {
                        iconName: "info"
                        onTriggered: {
                            root.fileNamePath = Core.recorder.filePath + "/" + model.fileName
                            root.fileName = model.fileName
                            root.index = index
                            PopupUtils.open(infoComponent)
                        }
                    }
                ]
            }

            onClicked: {
                if (player.playbackState !== Audio.PlayingState) {
                    root.sourceFile = "file://" + Core.recorder.filePath + "/" + model.fileName
                    root.fileNamePath = Core.recorder.filePath + "/" + model.fileName
                    root.fileName = model.fileName
                    player.source = sourceFile
                    player.play()
                } else {
                    player.stop()
                }
            }
        }
    }

    Component {
        id: removeComponent
        Dialog {
            id: removeDialog
            // TRANSLATORS: Title of the record remove dialog
            title: i18n.tr("Delete record")
            // TRANSLATORS: Question of the record remove dialog.
            text: i18n.tr("Are you sure you want to delete this file?")

            Label {
                text: root.fileName
            }

            ThinDivider {}

            Button {
                // TRANSLATORS: Delete button in the remove record dialog
                text: i18n.tr("Delete")
                color: LomiriColors.red
                onClicked: {
                    Core.recorder.deleteRecordFile(root.fileNamePath);
                    PopupUtils.close(removeDialog)
                }
            }

            Button {
                // TRANSLATORS: Cancel button in the remove record dialog
                text: i18n.tr("Cancel")
                onClicked: PopupUtils.close(removeDialog)
            }
        }
    }

    Component {
        id: renameComponent
        Dialog {
            id: renameDialog
            // TRANSLATORS: Title of the rename record dialog
            title: i18n.tr("Rename record file")
            // TRANSLATORS: Instructions of the record rename dialog.
            text: i18n.tr("Please enter the new file name.")

            TextField {
                id: fileNameTextField
                placeholderText: root.fileName
            }

            ThinDivider {}

            Button {
                // TRANSLATORS: Rename button in the rename record dialog
                text: i18n.tr("Rename")
                color: LomiriColors.green
                onClicked: {
                    Core.recorder.renameRecordFile(root.fileNamePath, fileNameTextField.text);
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
        id: infoComponent
        Dialog {
            id: infoDialog
            // TRANSLATORS: Title of the rename record dialog
            title: i18n.tr("Record information")

            Label {
                // TRANSLATORS: The name lable in the record information dialog
                text: i18n.tr("Name:")
                font.bold: true
            }

            Label {
                text: folderModel.get(root.index, "fileBaseName")
            }

            ThinDivider { }

            Label {
                // TRANSLATORS: The type lable in the record information dialog
                text: i18n.tr("Type:")
                font.bold: true
            }

            Label {
                text: folderModel.get(root.index, "fileSuffix")
            }

            ThinDivider { }

            Label {
                // TRANSLATORS: The size lable in the record information dialog
                text: i18n.tr("Size:")
                font.bold: true
            }

            Label {
                text: Math.round(folderModel.get(root.index, "fileSize") / 1000) < 1024 ? (folderModel.get(root.index, "fileSize") / 1000).toFixed(2) + " kB" : (folderModel.get(root.index, "fileSize") / (1000 * 1024)).toFixed(1) + " MB"
            }

            ThinDivider { }

            Label {
                // TRANSLATORS: The modified lable in the record information dialog
                text: i18n.tr("Modified:")
                font.bold: true
            }

            Label {
                text: folderModel.get(root.index, "fileModified")
            }

            ThinDivider { }

            Button {
                // TRANSLATORS: The close button of the record information dialog
                text: i18n.tr("Close")
                onClicked: PopupUtils.close(infoDialog)
            }
        }
    }
}
