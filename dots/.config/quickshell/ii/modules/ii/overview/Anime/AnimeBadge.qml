pragma ComponentBehavior: Bound
import qs.modules.common
import qs.modules.common.widgets
import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets

RowLayout {
    
    property alias text: textItem.text
    property int margin
    visible: text

    Rectangle {
        id: badge
        height: 32
        radius: 12
        color: Appearance.m3colors.m3onPrimary
        border.color: Appearance.m3colors.m3onPrimaryFixedVariant
        border.width: 1
        Layout.margins: margin
        implicitWidth: textItem.implicitWidth + 20

        Text {
            id: textItem
            anchors.centerIn: parent
            color: Appearance.m3colors.m3primary
            font.pixelSize: Appearance.font.pixelSize.small
        }
    }
}