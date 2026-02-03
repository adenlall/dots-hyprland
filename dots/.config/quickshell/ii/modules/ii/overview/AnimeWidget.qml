import qs.modules.common
import qs.modules.common.widgets
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Widgets
import qs.services.Anilist

Rectangle {
    color: Appearance.m3colors.m3secondary
    height: 300
    radius: 30
    width: parent.width
    RowLayout {
        anchors {
            left: parent.left
            top: parent.top
            bottom: parent.bottom
            margins: 15
        }
        width: parent.width
        height: parent.height
        Rectangle {
            height: parent.height
            width: 190
            color: "transparent"

            ClippingRectangle {
                width: 180
                height: parent.height
                radius: 25
                Image {
                    anchors.fill: parent
                    source: "https://s4.anilist.co/file/anilistcdn/media/anime/cover/large/bx167152-u0cBZkqDowHP.jpg"
                    fillMode: Image.PreserveAspectCrop
                }
            }
        }
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "transparent"
            Column {
                width: parent.width
                height: parent.height
                spacing: 10
                StyledText {
                    color: Appearance.m3colors.m3onSecondary
                    text: "Sentenced to be Hero"
                    font.weight: 900
                    font.pixelSize: Appearance.font.pixelSize.title
                }
                StyledText {
                    color: Appearance.m3colors.m3onSecondary
                    text: "EP 6 : in 5 day 20 hours"
                    font.weight: 400
                    font.pixelSize: Appearance.font.pixelSize.larger
                }
                Row{
                    spacing: 5
                    Rectangle {
                        width: childrenRect.width + 20
                        height: childrenRect.height + 5
                        color: Appearance.m3colors.m3onPrimary
                        radius: 12
                        border.color: Appearance.m3colors.m3onPrimaryFixedVariant
                        border.width: 1
                        StyledText {
                            anchors.centerIn: parent
                            color: Appearance.m3colors.m3primary
                            text: "Drama"
                            font.pixelSize: Appearance.font.pixelSize.small
                        }
                    }
                    Rectangle {
                        width: childrenRect.width + 20
                        height: childrenRect.height + 5
                        color: Appearance.m3colors.m3onPrimary
                        radius: 12
                        border.color: Appearance.m3colors.m3onPrimaryFixedVariant
                        border.width: 1
                        StyledText {
                            anchors.centerIn: parent
                            color: Appearance.m3colors.m3primary
                            text: "Action"
                            font.pixelSize: Appearance.font.pixelSize.small
                        }
                    }
                    Rectangle {
                        width: childrenRect.width + 20
                        height: childrenRect.height + 5
                        color: Appearance.m3colors.m3onPrimary
                        radius: 12
                        border.color: Appearance.m3colors.m3onPrimaryFixedVariant
                        border.width: 1
                        StyledText {
                            anchors.centerIn: parent
                            color: Appearance.m3colors.m3primary
                            text: "Trailer"
                            font.pixelSize: Appearance.font.pixelSize.small
                        }
                    }
                }
                Rectangle {
                    width: childrenRect.width + 20
                    height: childrenRect.height + 10
                    color: Appearance.m3colors.m3tertiary
                    radius: 9
                    StyledText{
                        anchors.centerIn: parent
                        color: Appearance.m3colors.m3onTertiary
                        text: "Login with Anilist"
                        font.pixelSize: Appearance.font.pixelSize.large
                    }
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            if (AuthManager.authenticated) {
                                AuthManager.logout()
                            } else {
                                AuthManager.authenticate()
                            }
                        }
                    }
                }
            }
        }
    }
}