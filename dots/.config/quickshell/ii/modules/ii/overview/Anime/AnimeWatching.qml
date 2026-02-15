pragma ComponentBehavior: Bound
import qs.modules.common
import qs.modules.common.widgets
import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets

Rectangle {
    property var animes: []   // ← put your real array here (can be empty!)

    Layout.fillWidth: true
    Layout.fillHeight: true
    color: Appearance.colors.colSurfaceContainerHigh
    radius: 20

    GridLayout {
        anchors.fill: parent
        anchors.margins: 10
        columns: 3
        rows: 2
        rowSpacing: 5
        columnSpacing: 5

        // ==================== SLOT 0 ====================
        Rectangle {
            visible: (animes.length > 0 && animes[0] !== undefined &&
                      animes[0].media !== undefined &&
                      animes[0].media.coverImage !== undefined)
            radius: 15
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Appearance.m3colors.m3onPrimaryContainer

            AnimePoster {
                src: visible ? animes[0].media.coverImage.large : ""
                h: parent.height
                w: parent.width
                rounded: 15
            }
        }

        // ==================== SLOT 1 ====================
        Rectangle {
            visible: (animes.length > 1 && animes[1] !== undefined &&
                      animes[1].media !== undefined &&
                      animes[1].media.coverImage !== undefined)
            radius: 15
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Appearance.m3colors.m3onPrimaryContainer

            AnimePoster {
                src: visible ? animes[1].media.coverImage.large : ""
                h: parent.height
                w: parent.width
                rounded: 15
            }
        }

        // ==================== SLOT 2 ====================
        Rectangle {
            visible: (animes.length > 2 && animes[2] !== undefined &&
                      animes[2].media !== undefined &&
                      animes[2].media.coverImage !== undefined)
            radius: 15
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Appearance.m3colors.m3onPrimaryContainer

            AnimePoster {
                src: visible ? animes[2].media.coverImage.large : ""
                h: parent.height
                w: parent.width
                rounded: 15
            }
        }

        // ==================== SLOT 3 ====================
        Rectangle {
            visible: (animes.length > 3 && animes[3] !== undefined &&
                      animes[3].media !== undefined &&
                      animes[3].media.coverImage !== undefined)
            radius: 15
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Appearance.m3colors.m3onPrimaryContainer

            AnimePoster {
                src: visible ? animes[3].media.coverImage.large : ""
                h: parent.height
                w: parent.width
                rounded: 15
            }
        }

        // ==================== SLOT 4 ====================
        Rectangle {
            visible: (animes.length > 4 && animes[4] !== undefined &&
                      animes[4].media !== undefined &&
                      animes[4].media.coverImage !== undefined)
            radius: 15
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Appearance.m3colors.m3onPrimaryContainer

            AnimePoster {
                src: visible ? animes[4].media.coverImage.large : ""
                h: parent.height
                w: parent.width
                rounded: 15
            }
        }

        // ==================== SLOT 5 ====================
        Rectangle {
            visible: (animes.length > 5 && animes[5] !== undefined &&
                      animes[5].media !== undefined &&
                      animes[5].media.coverImage !== undefined)
            radius: 15
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Appearance.m3colors.m3onPrimaryContainer

            AnimePoster {
                src: visible ? animes[5].media.coverImage.large : ""
                h: parent.height
                w: parent.width
                rounded: 15
            }
        }
    }
}