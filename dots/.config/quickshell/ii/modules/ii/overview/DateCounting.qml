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

    function parseDate(dateStr) {
        if (!dateStr || dateStr.length !== 8) return null;
        const year = parseInt(dateStr.substring(0, 4), 10);
        const month = parseInt(dateStr.substring(4, 6), 10) - 1;
        const day = parseInt(dateStr.substring(6, 8), 10);
        return new Date(year, month, day);
    }

    function dateDiff(dateStr1, dateStr2) {
        const d1 = parseDate(dateStr1);
        const d2 = parseDate(dateStr2);
        if (!d1 || !d2) return 0;
        const diffTime = d1 - d2;
        const diffDays = Math.floor(diffTime / (1000 * 60 * 60 * 24));
        return diffDays;
    }

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
            // Call dateDiff with the two date strings
            text: dateDiff(DateTime.rawDate, Config.options.time.timeCounting) + " days"
            Layout.alignment: Qt.AlignVCenter
        }
    }
}