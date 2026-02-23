pragma ComponentBehavior: Bound

import qs.modules.common
import qs.modules.ii.overview.Anime
import qs.modules.common.widgets
import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import qs.services
import QtPositioning


Rectangle {
    id: root
    property var watchingList: []
    property bool loading: true

    color: Appearance.m3colors.m3secondary
    height: 300
    radius: 30
    width: parent.width
    RowLayout {
        // visible: false
        anchors {
            top: parent.top
            right: parent.right
            bottom: parent.bottom
            left: parent.left
            margins: 15
        }
        width: parent.width
        height: parent.height
        Rectangle {
            height: parent.height
            width: 190
            color: "transparent"
            AnimePoster{
                src: watchingList[3]?.media?.coverImage?.large??""
                h: parent.height
            }
        }
        Rectangle {
            Layout.preferredWidth: parent.width * 0.3
            Layout.fillWidth: false
            Layout.fillHeight: true
            color: "transparent"
            // color: "red"
            Column {
                id: container
                width: parent.width
                height: parent.height
                spacing: 10
                StyledText {
                    width: parent.width
                    color: Appearance.m3colors.m3onSecondary
                    text: watchingList[3]?.media?.title?.userPreferred??""
                    font.weight: 900
                    font.pixelSize: Appearance.font.pixelSize.title
                    elide: Text.ElideRight
                    wrapMode: Text.NoWrap
                }
                StyledText {
                    color: Appearance.m3colors.m3onSecondary
                    text: watchingList[3]?.media?.nextAiringEpisode?.episode ? ("EP "+watchingList[3]?.media?.nextAiringEpisode?.episode+" : "+Anivice.getRemainingTime(watchingList[3]?.media?.nextAiringEpisode?.airingAt).formatted):""
                    font.weight: 400
                    font.pixelSize: Appearance.font.pixelSize.larger
                }
                Row {
                    id: genreRow
                    spacing: 5
                    Repeater {
                        model: watchingList[3]?.media?.genres?.slice(0, 3);
                        delegate: AnimeBadge {
                                required property string modelData
                                text:modelData
                            }
                    }
                }
            }
        }
        AnimeWatching{
            animes: watchingList
        }
    }
    Component.onCompleted: {
        Anivice.getUserWatching()
        .then(function(response) {
            response = response.MediaListCollection.lists.filter(item => item.name === "Watching")[0].entries
            root.watchingList = response
        })
    }


}