pragma Singleton
pragma ComponentBehavior: Bound

// Took many bits from https://github.com/caelestia-dots/shell (GPLv3)

import Quickshell
import Quickshell.Io
import QtQuick
import qs.services.network
import qs.modules.common

Singleton {
    id: root

    property bool wireguard: true

    property bool wireguardEnabled: false
    property bool wireguardStatus: false
    property bool wireguardScanning: false
    property string name: ""
    property var wireguardTarget
    readonly property list<var> parsedConfigs: []


    function enableWireguard(action = false): void {
        killtProcess.running = action;
        root.wireguardEnabled = action;
    }

    function connectConfig(conf): void {
        if(conf.trim() === root.name.trim()){
            killtProcess.running = true;
            return;
        }
        killtProcess.swapConf = conf.trim()
        killtProcess.running = true;
    }

    function toggleWireguard(): void {
        enableWireguard(!wireguardEnabled);
    }

    function rescanWireguard(): void {
        wireguardScanning = true;
        rescanProcess.running = true;
    }

    function removeConfig(conf): void {
        stripProcess.conf = conf;
        stripProcess.running = true;
    }

    Process {
        id: disConnectProcess
        running: false
        command: ["pkexec", Directories.wireguardPortalScriptPath, "down", root.name]
        stdout: StdioCollector {
            onStreamFinished: {
                root.name = ""
                root.wireguardTarget = ""
                root.wireguardStatus = false
            }
        }
    }
    
    Process {
        id: stripProcess
        property string conf:""
        running: false
        command: ["pkexec", Directories.wireguardPortalScriptPath, "strip", stripProcess.conf]
        stdout: StdioCollector {
            onStreamFinished: {
                stripProcess.conf = "";
            }
        }
    }
    
    Process {
        id: killtProcess
        property string swapConf:""
        running: false
        command: ["pkexec", Directories.wireguardPortalScriptPath, "kill"]
        stdout: StdioCollector {
            onStreamFinished: {
                root.name = ""
                root.wireguardTarget = ""
                root.wireguardStatus = false
                if(killtProcess.swapConf){
                    root.wireguardTarget = killtProcess.swapConf
                    connectProcess.running = true
                }
                killtProcess.swapConf = ""
            }
        }
    }
    
    Process {
        id: connectProcess
        running: false
        command: ["pkexec", Directories.wireguardPortalScriptPath, "up", root.wireguardTarget]
        stdout: StdioCollector {
            onStreamFinished: {
                root.name = root.wireguardTarget
                root.wireguardTarget = ""
                root.wireguardStatus = true
            }
        }
    }
    
    Process {
        id: liveProcess
        running: true
        command: ["pkexec", Directories.wireguardPortalScriptPath, "live"]
        stdout: StdioCollector {
            id: liveprocessname
            onStreamFinished: {
                if(liveprocessname.text.trim()){
                    root.name = liveprocessname.text.trim()
                    root.wireguardStatus = true
                }else{
                    root.name = ""
                    root.wireguardStatus = false
                }
            }
        }
    }
    
    Process {
        id: rescanProcess
        running: true
        command: ["pkexec", Directories.wireguardPortalScriptPath, "pull"]
        stdout: StdioCollector {
            id: configsraw
            onStreamFinished: {
                const parsed = configsraw.text.trim().replace(/.conf/g,"").split("\n");
                root.parsedConfigs = parsed
                liveProcess.running = true
            }
        }
    }

}
