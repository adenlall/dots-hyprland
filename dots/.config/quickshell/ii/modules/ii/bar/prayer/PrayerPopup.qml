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
        implicitWidth: Math.max(header.implicitWidth, gridLayout.implicitWidth)
        implicitHeight: gridLayout.implicitHeight
        spacing: 5

        // Header
        ColumnLayout {
            id: header
            Layout.alignment: Qt.AlignHCenter
            spacing: 2

            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 6

                MaterialSymbol {
                    fill: 0
                    font.weight: Font.Medium
                    text: "location_on"
                    iconSize: Appearance.font.pixelSize.large
                    color: Appearance.colors.colOnSurfaceVariant
                }

                StyledText {
                    text: Prayer.data.next
                    font {
                        weight: Font.Medium
                        pixelSize: Appearance.font.pixelSize.normal
                    }
                    color: Appearance.colors.colOnSurfaceVariant
                }
            }
            StyledText {
                id: temp
                font.pixelSize: Appearance.font.pixelSize.smaller
                color: Appearance.colors.colOnSurfaceVariant
                text: Prayer.data.temp + " • " + Translation.tr("Feels like %1").arg(Prayer.data.tempFeelsLike)
            }
        }

        // Metrics grid
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
