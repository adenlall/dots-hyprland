import QtQuick
import qs.services
import qs.modules.common
import qs.modules.common.functions
import qs.modules.common.widgets

QuickToggleModel {
    name: Translation.tr("Wireguard Profiles")
    statusText: Wireguard.wireguardName
    tooltipText: Translation.tr("%1 | Right-click to configure").arg(Network.networkName)
    icon: 'vpn_key'

    toggled: Wireguard.wireguardStatus
    mainAction: () => Wireguard.toggleWireguard()
    hasMenu: true
}
