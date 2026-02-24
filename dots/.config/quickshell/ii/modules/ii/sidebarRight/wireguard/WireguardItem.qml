import qs
import qs.modules.common
import qs.modules.common.widgets
import qs.services
import qs.services.network
import QtQuick
import QtQuick.Layouts

DialogListItem {
    id: root
    required property string wgConfig
    enabled: !(Network.wifiConnectTarget === root.wgConfig)

    // active: (wgConfig?.askingPassword || wgConfig?.active) ?? false
    onClicked: {
        Wireguard.connectConfig(wgConfig);
    }

    contentItem: ColumnLayout {
        anchors {
            fill: parent
            topMargin: root.verticalPadding
            bottomMargin: root.verticalPadding
            leftMargin: root.horizontalPadding
            rightMargin: root.horizontalPadding
        }
        spacing: 0

        RowLayout {
            // Name
            spacing: 10
            MaterialSymbol {
                iconSize: Appearance.font.pixelSize.larger
                text: "vpn_key"
                color: Appearance.colors.colOnSurfaceVariant
            }
            StyledText {
                Layout.fillWidth: true
                color: Appearance.colors.colOnSurfaceVariant
                elide: Text.ElideRight
                text: root.wgConfig ?? Translation.tr("Unknown")
                textFormat: Text.PlainText
            }
            MaterialSymbol {
                visible: true
                text: (root.wgConfig.trim() === Wireguard.name.trim()) ? "check" : Wireguard.wireguardTarget === root.wgConfig ? "settings_ethernet" : "lock"
                iconSize: Appearance.font.pixelSize.larger
                color: Appearance.colors.colOnSurfaceVariant
            }
        }

        // ColumnLayout { // Password
        //     id: passwordPrompt
        //     Layout.topMargin: 8
        //     visible: root.wgConfig?.askingPassword ?? false

        //     MaterialTextField {
        //         id: passwordField
        //         Layout.fillWidth: true
        //         placeholderText: Translation.tr("Password")

        //         // Password
        //         echoMode: TextInput.Password
        //         inputMethodHints: Qt.ImhSensitiveData

        //         onAccepted: {
        //             Network.changePassword(root.wgConfig, passwordField.text);
        //         }
        //     }

        //     RowLayout {
        //         Layout.fillWidth: true

        //         Item {
        //             Layout.fillWidth: true
        //         }

        //         DialogButton {
        //             buttonText: Translation.tr("Cancel")
        //             onClicked: {
        //                 root.wgConfig.askingPassword = false;
        //             }
        //         }

        //         DialogButton {
        //             buttonText: Translation.tr("Connect")
        //             onClicked: {
        //                 Network.changePassword(root.wgConfig, passwordField.text);
        //             }
        //         }
        //     }
        // }

        // ColumnLayout { // Public wifi login page
        //     id: publicWifiPortal
        //     Layout.topMargin: 8
        //     visible: (root.wgConfig?.active && (root.wgConfig?.security ?? "").trim().length === 0) ?? false

        //     RowLayout {
        //         DialogButton {
        //             Layout.fillWidth: true
        //             buttonText: Translation.tr("Open network portal")
        //             colBackground: Appearance.colors.colLayer4
        //             colBackgroundHover: Appearance.colors.colLayer4Hover
        //             colRipple: Appearance.colors.colLayer4Active
        //             onClicked: {
        //                 Network.openPublicWifiPortal()
        //                 GlobalStates.sidebarRightOpen = false
        //             }
        //         }
        //     }
        // }

        Item {
            Layout.fillHeight: true
        }
    }
}
