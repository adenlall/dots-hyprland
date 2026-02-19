import qs.services
import qs.modules.common
import qs.modules.common.widgets

import QtQuick
import QtQuick.Layouts
import qs.modules.ii.bar

StyledPopup {
    id: root

    ColumnLayout {
        id: columnLayout
        anchors.centerIn: parent
        implicitWidth: gridLayout.implicitWidth
        implicitHeight: gridLayout.implicitHeight
        spacing: 5

        GridLayout {
            id: gridLayout
            columns: 1
            rowSpacing: 5
            columnSpacing: 5
            uniformCellWidths: true
            Repeater {
                model: Prayer.data.table
                PrayerCard {
                    title:  modelData.pray
                    symbol: modelData.symbol
                    value:  modelData.time
                    diff: modelData.diff
                    textColor: Appearance.m3colors.m3tertiary
                    fontWeight: modelData.pray===Prayer.data.next.prayer ? 900 : 400
                    bgColor: modelData.pray===Prayer.data.next.prayer ? Appearance.m3colors.m3onTertiary : Appearance.colors.colSurfaceContainerHigh
                }
            }
        }

        // Footer: last refresh
        StyledText {
            Layout.alignment: Qt.AlignHCenter
            text: Translation.tr("Last refresh: %1").arg(Prayer.data.lastRefresh)
            font {
                weight: Font.Medium
                pixelSize: Appearance.font.pixelSize.smaller
            }
            color: Appearance.colors.colOnSurfaceVariant
        }
    }
}
