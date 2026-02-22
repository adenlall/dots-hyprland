pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell
import qs
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.common.functions

RowLayout {
    visible: Config.options.time.timeCounting
    id: root
    Layout.topMargin: 4
    Layout.bottomMargin: 4
    Layout.rightMargin: 10
    implicitHeight: 40

    Rectangle {
        id: bg
        anchors.fill: parent
        color: Appearance.m3colors.m3tertiary
        radius: 20
    }

    RowLayout {
        id: rowLayout
        anchors.centerIn: parent
        Layout.rightMargin: 5
        Layout.leftMargin: 5

        MaterialSymbol {
            fill: 0
            text: "history"
            iconSize: Appearance.font.pixelSize.huge
            color: Appearance.m3colors.m3onTertiary
            Layout.alignment: Qt.AlignVCenter
        }

        StyledText {
            visible: true
            font.pixelSize: Appearance.font.pixelSize.small
            font.weight: 800
            color: Appearance.m3colors.m3onTertiary
            text: DateTime.rawDate-Config.options.time.timeCounting + " days "
            Layout.alignment: Qt.AlignVCenter
        }
    }
    
}
