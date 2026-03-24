pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Io
import QtQuick
import qs.services.network
import qs.modules.common

Singleton {
    id: root

    property bool theming: false
    property string currentTheme
    property string targetTheme

    readonly property list<var> installedThemes: []

    function setTheme(theme): void {
        targetTheme = theme.trim()
        setThemeProcess.running = true;
    }

    function theme(): void {
        if(Config.options.appearance.palette.accentColorFolderTheming){
            themingProcess.running = true;
        }
    }


    Process {
        id: installedThemesProccess
        running: true
        command: [Directories.iconsHelper, "pull"]
        stdout: StdioCollector {
            id: pulledStdout
            onStreamFinished: {
                installedThemes = pulledStdout.text.split("\n")
            }
        }
    }

    Process {
        id: currentThemeProcess
        running: true
        command: [Directories.iconsHelper, "current"]
        stdout: StdioCollector {
            id: currentStdout
            onStreamFinished: {
                currentTheme = currentStdout.text
            }
        }
    }

    Process {
        id: setThemeProcess
        running: true
        command: [Directories.iconsHelper, "set", targetTheme]
        stdout: StdioCollector {
            onStreamFinished: {
                targetTheme = ""
                currentThemeProcess.running = true
                theme()
            }
        }
    }

    Process {
        id: themingProcess
        running: false
        command: [Directories.iconsHelper, "theme"]
        onExited: (exitCode, exitStatus) => {
            if (exitCode !== 0) {
                Quickshell.execDetached(["notify-send", 
                    Translation.tr("Theming Service"), 
                    Translation.tr("Icon pack set but theming Failed. The selected Icon theme is not supported yet"),
                    "-a", "Shell"
                ])
            }
        }
    }
}
