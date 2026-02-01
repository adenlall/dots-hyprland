pragma ComponentBehavior: Bound

import qs.modules.common
import qs.modules.common.widgets
import qs.services
import Quickshell
import QtQuick
import QtQuick.Layouts

MouseArea {
    id: root
    property bool hovered: false
    implicitWidth: rowLayout.implicitWidth + 10
    implicitHeight: Appearance.sizes.barHeight - 15

    acceptedButtons: Qt.LeftButton | Qt.RightButton
    hoverEnabled: !Config.options.bar.tooltips.clickToShow

    onPressed: {
        if (mouse.button === Qt.RightButton) {
            Prayer.getData();
            Quickshell.execDetached(["notify-send", 
                Translation.tr("Prayer"), 
                Translation.tr("Refreshing (manually triggered)")
                , "-a", "Shell"
            ])
            mouse.accepted = false
        }
    }

    Rectangle {
        id: bg
        anchors.fill: parent
        color: Appearance.m3colors.m3tertiary
        radius: 10
    }

    RowLayout {
        id: rowLayout
        anchors.centerIn: parent

        MaterialSymbol {
            fill: 0
            // TODO: finish
            text: Prayer.data.next.symbol
            iconSize: Appearance.font.pixelSize.large
            color: Appearance.m3colors.m3onTertiary
            Layout.alignment: Qt.AlignVCenter
        }

        StyledText {
            visible: true
            font.pixelSize: Appearance.font.pixelSize.small
            color: Appearance.m3colors.m3onTertiary
            text: Prayer.data.next.remaining
            Layout.alignment: Qt.AlignVCenter
        }
    }

    PrayerPopup {
        id: prayerPopup
        hoverTarget: root
    }
}
