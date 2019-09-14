/*
 * Copyright 2015  Martin Klapetek <mklapetek@kde.org>
 * Copyright 2019  Linus Jahn <lnj@kaidan.im>
 * Copyright 2019  Jonah Brüchert <jbb@kaidan.im>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License or (at your option) version 3 or any later version
 * accepted by the membership of KDE e.V. (or its successor approved
 * by the membership of KDE e.V.), which shall act as a proxy
 * defined in Section 14 of version 3 of the license.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.7
import QtQuick.Controls 2.0 as Controls
import QtQuick.Layouts 1.7
import QtQuick.Dialogs 1.0

import org.kde.kirigami 2.9 as Kirigami
import org.kde.people 1.0 as KPeople

import org.kde.phonebook 1.0


Kirigami.ScrollablePage {
    title: i18n("Address book")

    FileDialog {
        id: importFileDialog
        selectMultiple: false
        selectExisting: true
        onAccepted: importer.importVCards(fileUrl)
    }

    ContactImporter {
        id: importer
    }

    // Brighter background color
    Kirigami.Theme.colorSet: Kirigami.Theme.View
    background: Rectangle {
        color: Kirigami.Theme.backgroundColor
    }

    actions {
        main: Kirigami.Action {
            icon.name: "contact-new-symbolic"
            text: i18n("Create new")
            onTriggered: {
                pageStack.push(Qt.resolvedUrl("AddContactPage.qml"), {state: "create"})
            }
        }

        contextualActions: [
            Kirigami.Action {
                icon.name: "document-import"
                text: i18n("Import contacts")
                onTriggered: {
                    importFileDialog.open()
                }
            }
        ]
    }

    Controls.Label {
        anchors.centerIn: parent
        text: i18n("No contacts")
        visible: contactsModel.count === 0
    }

    header: Rectangle {
        clip: true
        id: header
        color: Kirigami.Theme.backgroundColor
        height: searchField.implicitHeight + 2 * Kirigami.Units.largeSpacing
        width: root.width

        Kirigami.SearchField {
            id: searchField
            anchors.centerIn: parent
            anchors.margins: Kirigami.Units.largeSpacing
            width: parent.width - 2 * Kirigami.Units.largeSpacing
            onTextChanged: filterModel.setFilterFixedString(text)
        }
    }

    ListView {
        id: contactsList

        property bool delegateSelected: false
        property string numberToCall

        section.property: "display"
        section.criteria: ViewSection.FirstCharacter
        clip: true
        model: KPeople.PersonsSortFilterProxyModel {
            id: filterModel
            filterRole: Qt.DisplayRole

            sourceModel: KPeople.PersonsModel {
                id: contactsModel
            }
        }

        Component {
            id: contactListDelegate
            ContactListItem {
                height: Kirigami.Units.gridUnit * 3
                name: model.display
                icon: model.decoration
                personUri: model.personUri

                actions: [
                    Kirigami.Action {
                        icon.name: "mail-message"
                        onTriggered: {
                            personActions.triggerAction(KPeople.TextChatAction)
                        }
                    },
                    Kirigami.Action {
                        icon.name: "call-start"
                        onTriggered: {
                            personActions.triggerAction(KPeople.AudioCallAction)
                        }
                    }
                ]

                onClicked: {
                    pageStack.push(detailPage, {
                                        personUri: model.personUri
                                   })
                }
            }
        }

        delegate: Kirigami.DelegateRecycler {
            width: parent.width
            sourceComponent: contactListDelegate
        }
    }
}
