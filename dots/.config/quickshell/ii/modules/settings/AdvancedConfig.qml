import QtQuick
import qs.services
import qs.modules.common
import qs.modules.common.widgets

import qs.services.network
import QtQuick.Layouts
import Quickshell

ContentPage {
    forceWidth: true

    ContentSection {
        icon: "colors"
        title: Translation.tr("Color generation")

        ConfigSwitch {
            buttonIcon: "hardware"
            text: Translation.tr("Shell & utilities")
            checked: Config.options.appearance.wallpaperTheming.enableAppsAndShell
            onCheckedChanged: {
                Config.options.appearance.wallpaperTheming.enableAppsAndShell = checked;
            }
        }
        ConfigSwitch {
            buttonIcon: "tv_options_input_settings"
            text: Translation.tr("Qt apps")
            checked: Config.options.appearance.wallpaperTheming.enableQtApps
            onCheckedChanged: {
                Config.options.appearance.wallpaperTheming.enableQtApps = checked;
            }
            StyledToolTip {
                text: Translation.tr("Shell & utilities theming must also be enabled")
            }
        }
        ConfigSwitch {
            buttonIcon: "terminal"
            text: Translation.tr("Terminal")
            checked: Config.options.appearance.wallpaperTheming.enableTerminal
            onCheckedChanged: {
                Config.options.appearance.wallpaperTheming.enableTerminal = checked;
            }
            StyledToolTip {
                text: Translation.tr("Shell & utilities theming must also be enabled")
            }
        }
        ConfigRow {
            uniform: true
            ConfigSwitch {
                buttonIcon: "dark_mode"
                text: Translation.tr("Force dark mode in terminal")
                checked: Config.options.appearance.wallpaperTheming.terminalGenerationProps.forceDarkMode
                onCheckedChanged: {
                     Config.options.appearance.wallpaperTheming.terminalGenerationProps.forceDarkMode= checked;
                }
                StyledToolTip {
                    text: Translation.tr("Ignored if terminal theming is not enabled")
                }
            }
        }

        ConfigSpinBox {
            icon: "invert_colors"
            text: Translation.tr("Terminal: Harmony (%)")
            value: Config.options.appearance.wallpaperTheming.terminalGenerationProps.harmony * 100
            from: 0
            to: 100
            stepSize: 10
            onValueChanged: {
                Config.options.appearance.wallpaperTheming.terminalGenerationProps.harmony = value / 100;
            }
        }
        ConfigSpinBox {
            icon: "gradient"
            text: Translation.tr("Terminal: Harmonize threshold")
            value: Config.options.appearance.wallpaperTheming.terminalGenerationProps.harmonizeThreshold
            from: 0
            to: 100
            stepSize: 10
            onValueChanged: {
                Config.options.appearance.wallpaperTheming.terminalGenerationProps.harmonizeThreshold = value;
            }
        }
        ConfigSpinBox {
            icon: "format_color_text"
            text: Translation.tr("Terminal: Foreground boost (%)")
            value: Config.options.appearance.wallpaperTheming.terminalGenerationProps.termFgBoost * 100
            from: 0
            to: 100
            stepSize: 10
            onValueChanged: {
                Config.options.appearance.wallpaperTheming.terminalGenerationProps.termFgBoost = value / 100;
            }
        }
    }


    ContentSection {
        icon: "vpn_key"
        title: Translation.tr("Wireguard VPN")

        ConfigRow{
            RippleButtonWithIcon {
                Layout.fillWidth: true
                // materialIcon: "music_cast"
                StyledToolTip {
                    text: Translation.tr("Browse for a Wireguard config file")
                }
                onClicked: {
                    Quickshell.execDetached(Directories.selectWireguardConfigScriptPath);
                }
                mainContentComponent: Component {
                    RowLayout {
                        spacing: 10
                        StyledText {
                            font.pixelSize: Appearance.font.pixelSize.small
                            text: ((Config.options.networking.wireguard.tempConfigPath===""||Config.options.networking.wireguard.tempConfigPath===null) ? "Pick Wireguard .conf File" : Config.options.networking.wireguard.tempConfigPath)
                            color: Appearance.colors.colOnSecondaryContainer
                        }
                    }
                }
            }
            SelectionGroupButton {
                id: paletteButton
                buttonIcon: "add"
                buttonText: "Add to /etc/wireguard"
                // toggled: root.currentValue == modelData.value
                onClicked: {
                    Wireguard.addConfig();
                }
            }
        }

        ContentSubsection { // Show all configs at /etc/wireguard
            title: Translation.tr("/etc/wireguard configs")
            Layout.fillWidth: true
            Repeater {
                model: Wireguard.parsedConfigs
                ConfigRow {
                    id: ---
                    visible: true
                    RippleButton {
                        Layout.fillWidth: true
                        implicitHeight: contentItem.implicitHeight + 8 * 2
                        font.pixelSize: Appearance.font.pixelSize.small
                        contentItem: RowLayout {
                            spacing: 10
                            OptionalMaterialSymbol {
                                icon: "vpn_key"
                                iconSize: Appearance.font.pixelSize.larger
                            }
                            StyledText {
                                Layout.fillWidth: true
                                text: modelData
                                color: Appearance.colors.colOnSecondaryContainer
                            }
                            SelectionGroupButton {
                                id: paletteButton
                                buttonIcon: "delete"
                                buttonText: "Delete"
                                // toggled: root.currentValue == modelData.value
                                onClicked: {
                                    Wireguard.removeConfig(modelData);
                                    Wireguard.rescanWireguard()
                                    // ("lay-"+modelData).visible = false
                                }
                            }
                        }
                    }
                }
            }
        }
    }


}