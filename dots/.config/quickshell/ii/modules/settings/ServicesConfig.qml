import QtQuick
import QtQuick.Layouts
import qs.services
import qs.modules.common
import qs.modules.common.widgets

ContentPage {
    forceWidth: true

    ContentSection {
        icon: "neurology"
        title: Translation.tr("AI")

        MaterialTextArea {
            Layout.fillWidth: true
            placeholderText: Translation.tr("System prompt")
            text: Config.options.ai.systemPrompt
            wrapMode: TextEdit.Wrap
            onTextChanged: {
                Qt.callLater(() => {
                    Config.options.ai.systemPrompt = text;
                });
            }
        }
    }

    ContentSection {
        icon: "music_cast"
        title: Translation.tr("Music Recognition")

        ConfigSpinBox {
            icon: "timer_off"
            text: Translation.tr("Total duration timeout (s)")
            value: Config.options.musicRecognition.timeout
            from: 10
            to: 100
            stepSize: 2
            onValueChanged: {
                Config.options.musicRecognition.timeout = value;
            }
        }
        ConfigSpinBox {
            icon: "av_timer"
            text: Translation.tr("Polling interval (s)")
            value: Config.options.musicRecognition.interval
            from: 2
            to: 10
            stepSize: 1
            onValueChanged: {
                Config.options.musicRecognition.interval = value;
            }
        }
    }

    ContentSection {
        icon: "cell_tower"
        title: Translation.tr("Networking")

        MaterialTextArea {
            Layout.fillWidth: true
            placeholderText: Translation.tr("User agent (for services that require it)")
            text: Config.options.networking.userAgent
            wrapMode: TextEdit.Wrap
            onTextChanged: {
                Config.options.networking.userAgent = text;
            }
        }
    }

    ContentSection {
        icon: "memory"
        title: Translation.tr("Resources")

        ConfigSpinBox {
            icon: "av_timer"
            text: Translation.tr("Polling interval (ms)")
            value: Config.options.resources.updateInterval
            from: 100
            to: 10000
            stepSize: 100
            onValueChanged: {
                Config.options.resources.updateInterval = value;
            }
        }
        
    }

    ContentSection {
        icon: "file_open"
        title: Translation.tr("Save paths")

        MaterialTextArea {
            Layout.fillWidth: true
            placeholderText: Translation.tr("Video Recording Path")
            text: Config.options.screenRecord.savePath
            wrapMode: TextEdit.Wrap
            onTextChanged: {
                Config.options.screenRecord.savePath = text;
            }
        }
        
        MaterialTextArea {
            Layout.fillWidth: true
            placeholderText: Translation.tr("Screenshot Path (leave empty to just copy)")
            text: Config.options.screenSnip.savePath
            wrapMode: TextEdit.Wrap
            onTextChanged: {
                Config.options.screenSnip.savePath = text;
            }
        }
    }

    ContentSection {
        icon: "search"
        title: Translation.tr("Search")

        ConfigSwitch {
            text: Translation.tr("Use Levenshtein distance-based algorithm instead of fuzzy")
            checked: Config.options.search.sloppy
            onCheckedChanged: {
                Config.options.search.sloppy = checked;
            }
            StyledToolTip {
                text: Translation.tr("Could be better if you make a ton of typos,\nbut results can be weird and might not work with acronyms\n(e.g. \"GIMP\" might not give you the paint program)")
            }
        }

        ContentSubsection {
            title: Translation.tr("Prefixes")
            ConfigRow {
                uniform: true
                MaterialTextArea {
                    Layout.fillWidth: true
                    placeholderText: Translation.tr("Action")
                    text: Config.options.search.prefix.action
                    wrapMode: TextEdit.Wrap
                    onTextChanged: {
                        Config.options.search.prefix.action = text;
                    }
                }
                MaterialTextArea {
                    Layout.fillWidth: true
                    placeholderText: Translation.tr("Clipboard")
                    text: Config.options.search.prefix.clipboard
                    wrapMode: TextEdit.Wrap
                    onTextChanged: {
                        Config.options.search.prefix.clipboard = text;
                    }
                }
                MaterialTextArea {
                    Layout.fillWidth: true
                    placeholderText: Translation.tr("Emojis")
                    text: Config.options.search.prefix.emojis
                    wrapMode: TextEdit.Wrap
                    onTextChanged: {
                        Config.options.search.prefix.emojis = text;
                    }
                }
            }

            ConfigRow {
                uniform: true
                MaterialTextArea {
                    Layout.fillWidth: true
                    placeholderText: Translation.tr("Math")
                    text: Config.options.search.prefix.math
                    wrapMode: TextEdit.Wrap
                    onTextChanged: {
                        Config.options.search.prefix.math = text;
                    }
                }
                MaterialTextArea {
                    Layout.fillWidth: true
                    placeholderText: Translation.tr("Shell command")
                    text: Config.options.search.prefix.shellCommand
                    wrapMode: TextEdit.Wrap
                    onTextChanged: {
                        Config.options.search.prefix.shellCommand = text;
                    }
                }
                MaterialTextArea {
                    Layout.fillWidth: true
                    placeholderText: Translation.tr("Web search")
                    text: Config.options.search.prefix.webSearch
                    wrapMode: TextEdit.Wrap
                    onTextChanged: {
                        Config.options.search.prefix.webSearch = text;
                    }
                }
            }
        }
        ContentSubsection {
            title: Translation.tr("Web search")
            MaterialTextArea {
                Layout.fillWidth: true
                placeholderText: Translation.tr("Base URL")
                text: Config.options.search.engineBaseUrl
                wrapMode: TextEdit.Wrap
                onTextChanged: {
                    Config.options.search.engineBaseUrl = text;
                }
            }
        }
    }

    ContentSection {
        icon: "weather_mix"
        title: Translation.tr("Weather")
        ConfigRow {
            ConfigSwitch {
                buttonIcon: "assistant_navigation"
                text: Translation.tr("Enable GPS based location")
                checked: Config.options.bar.weather.enableGPS
                onCheckedChanged: {
                    Config.options.bar.weather.enableGPS = checked;
                }
            }
            ConfigSwitch {
                buttonIcon: "thermometer"
                text: Translation.tr("Fahrenheit unit")
                checked: Config.options.bar.weather.useUSCS
                onCheckedChanged: {
                    Config.options.bar.weather.useUSCS = checked;
                }
                StyledToolTip {
                    text: Translation.tr("It may take a few seconds to update")
                }
            }
        }
        
        MaterialTextArea {
            Layout.fillWidth: true
            placeholderText: Translation.tr("City name")
            text: Config.options.bar.weather.city
            wrapMode: TextEdit.Wrap
            onTextChanged: {
                Config.options.bar.weather.city = text;
            }
        }
        ConfigSpinBox {
            icon: "av_timer"
            text: Translation.tr("Polling interval (m)")
            value: Config.options.bar.weather.fetchInterval
            from: 5
            to: 50
            stepSize: 5
            onValueChanged: {
                Config.options.bar.weather.fetchInterval = value;
            }
        }
    }

    ContentSection {
        icon: "prayer_times"
        title: Translation.tr("Prayer")

        ContentSubsection {
            title: Translation.tr("Coordinates")
            ConfigRow {
                uniform: true
                MaterialTextArea {
                    Layout.fillWidth: true
                    placeholderText: Translation.tr("Latitude")
                    text: Config.options.bar.prayer.latitude
                    wrapMode: TextEdit.Wrap
                    onTextChanged: {
                        Config.options.bar.prayer.latitude = text;
                    }
                }
                MaterialTextArea {
                    Layout.fillWidth: true
                    placeholderText: Translation.tr("Longitude")
                    text: Config.options.bar.prayer.longitude
                    wrapMode: TextEdit.Wrap
                    onTextChanged: {
                        Config.options.bar.prayer.longitude = text;
                    }
                }
            }
        }
        ConfigRow {
            ConfigSwitch {
                buttonIcon: "nest_clock_farsight_analog"
                text: Translation.tr("Auto time zone")
                checked: Config.options.bar.prayer.timezone_auto
                onCheckedChanged: {
                    Config.options.bar.prayer.timezone_auto = checked;
                }
            }
        }
        ConfigSpinBox {
            icon: "av_timer"
            text: Translation.tr("Timezone relative to UTC")
            value: Config.options.bar.prayer.timezone
            from: -12
            to: 12
            stepSize: 1
            onValueChanged: {
                Config.options.bar.prayer.timezone = value;
            }
        }
        ConfigSpinBox {
            icon: "av_timer"
            text: Translation.tr("Polling interval (m)")
            value: Config.options.bar.prayer.fetchInterval
            from: 1
            to: 60
            stepSize: 5
            onValueChanged: {
                Config.options.bar.prayer.fetchInterval = value;
            }
        }

        ContentSubsection {
            title: Translation.tr("Prayers Option")
            Layout.fillWidth: true

            ConfigRow {
                uniform: true
                ConfigSwitch {
                    buttonIcon: Prayer.symbols["imsak"]
                    text: Translation.tr("imsak")
                    checked: Config.options.bar.prayer.prayerControl.imsak
                    onCheckedChanged: {
                        Config.options.bar.prayer.prayerControl.imsak = checked;
                        Prayer.getData();
                    }
                }
                ConfigSwitch {
                    buttonIcon: Prayer.symbols["fajr"]
                    text: Translation.tr("Fajr")
                    checked: Config.options.bar.prayer.prayerControl.fajr
                    onCheckedChanged: {
                        Config.options.bar.prayer.prayerControl.fajr = checked;
                        Prayer.getData();
                    }
                }
                ConfigSwitch {
                    buttonIcon: Prayer.symbols["sunrise"]
                    text: Translation.tr("Sunrise")
                    checked: Config.options.bar.prayer.prayerControl.sunrise
                    onCheckedChanged: {
                        Config.options.bar.prayer.prayerControl.sunrise = checked;
                        Prayer.getData();
                    }
                }
            }
            ConfigRow {
                uniform: true
                ConfigSwitch {
                    buttonIcon: Prayer.symbols["dhuhr"]
                    text: Translation.tr("Duhr")
                    checked: Config.options.bar.prayer.prayerControl.dhuhr
                    onCheckedChanged: {
                        Config.options.bar.prayer.prayerControl.dhuhr = checked;
                        Prayer.getData();
                    }
                }
                ConfigSwitch {
                    buttonIcon: Prayer.symbols["asr"]
                    text: Translation.tr("Asr")
                    checked: Config.options.bar.prayer.prayerControl.asr
                    onCheckedChanged: {
                        Config.options.bar.prayer.prayerControl.asr = checked;
                        Prayer.getData();
                    }
                }
                ConfigSwitch {
                    buttonIcon: Prayer.symbols["sunset"]
                    text: Translation.tr("Sunset")
                    checked: Config.options.bar.prayer.prayerControl.sunset
                    onCheckedChanged: {
                        Config.options.bar.prayer.prayerControl.sunset = checked;
                        Prayer.getData();
                    }
                }
            }
            ConfigRow {
                uniform: true
                ConfigSwitch {
                    buttonIcon: Prayer.symbols["maghrib"]
                    text: Translation.tr("Maghrib")
                    checked: Config.options.bar.prayer.prayerControl.maghrib
                    onCheckedChanged: {
                        Config.options.bar.prayer.prayerControl.maghrib = checked;
                        Prayer.getData();
                    }
                }
                ConfigSwitch {
                    buttonIcon: Prayer.symbols["isha"]
                    text: Translation.tr("Isha")
                    checked: Config.options.bar.prayer.prayerControl.isha
                    onCheckedChanged: {
                        Config.options.bar.prayer.prayerControl.isha = checked;
                        Prayer.getData();
                    }
                }
                ConfigSwitch {
                    buttonIcon: Prayer.symbols["midnight"]
                    text: Translation.tr("Midnight")
                    checked: Config.options.bar.prayer.prayerControl.midnight
                    onCheckedChanged: {
                        Config.options.bar.prayer.prayerControl.midnight = checked;
                        Prayer.getData();
                    }
                }
            }
        }
    }
}
