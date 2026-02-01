import QtQuick
import QtQuick.Layouts

import qs.modules.common
import qs.modules.common.widgets

Rectangle {
    id: root
    radius: Appearance.rounding.small
    color: bgColor
    implicitWidth: columnLayout.implicitWidth + 14 * 2
    implicitHeight: columnLayout.implicitHeight + 14 * 2
    Layout.fillWidth: parent

    property alias title: title.text
    property alias value: value.text
    property alias symbol: symbol.text
    property color textColor
    property color bgColor
    property int fontWeight

    ColumnLayout {
        id: columnLayout
        anchors.fill: parent
        spacing: -10
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            MaterialSymbol {
                id: symbol
                fill: 0
                iconSize: Appearance.font.pixelSize.normal
                color: textColor
            }
            StyledText {
                id: title
                font.pixelSize: Appearance.font.pixelSize.smaller
                color: textColor
            }
        }
        StyledText {
            id: value
            Layout.alignment: Qt.AlignHCenter
            // font.pixelSize: Appearance.font.pixelSize.small
            color: Appearance.colors.colOnSurfaceVariant
            font.weight: fontWeight
        }
    }
}
