pragma ComponentBehavior: Bound

import qs.modules.common
import qs.modules.ii.overview.Anime
import qs.modules.common.widgets
import QtQuick
import Quickshell.Widgets


ClippingRectangle {
    property int w: 180
    property int h: 300
    property int rounded: 25
    property string src: ""
    width: w
    height: h
    radius: rounded
    Image {
        anchors.fill: parent
        source: src || ""
        fillMode: Image.PreserveAspectCrop
    }
}