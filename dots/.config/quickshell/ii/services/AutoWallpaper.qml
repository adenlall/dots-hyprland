pragma ComponentBehavior: Bound

import Quickshell
import QtQuick
import qs.modules.common
import qs.services


Item {
    id: root
    readonly property int fetchInterval: Config.options.background.autoSwitch.interval * 60000 // x*minute
    readonly property int enable: Config.options.background.autoSwitch.enable

    Timer {
        running: enable
        repeat: true
        interval: fetchInterval
        triggeredOnStart: false
        onTriggered: Wallpapers.randomFromCurrentFolder();
    }
}
