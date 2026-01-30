pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Io
import QtPositioning
import qs.modules.common

import QtQuick 6.0
import "Praytime.js" as PrayTimeModule


Singleton {
    id: root
    readonly property int fetchInterval: Config.options.bar.prayer.fetchInterval * 60 * 30 // 3 minute
    readonly property real latitude: Config.options.bar.prayer.latitude
    readonly property real longitude: Config.options.bar.prayer.longitude
    readonly property real timezone: Config.options.bar.prayer.timezone
    property var prayTime: new PrayTimeModule.PrayTime("ISNA")
    
    onLatitudeChanged: {
        root.getData();
    }
    onTimezoneChanged: {
        root.getData();
    }
    onLongitudeChanged: {
        root.getData();
    }

    property var symbols: ({
		imsak    : 'ev_shadow',
		fajr     : 'moon_stars',
		sunrise  : 'wb_twilight',
		dhuhr    : 'wb_sunny',
		asr      : 'sunny_snowing',
		sunset   : 'routine',
		maghrib  : 'water_lux',
		isha     : 'stars_2',
		midnight : 'forest'
	})

    property var data : ({
        next:{
            prayer:'',
            remaining:'',
            time:'',
            symbol:''
        },
        table:[]
    })

    function getData() {
        var dd = new Date();
        var time = dd.getHours()+""+dd.getMinutes();
        var rawtimes = prayTime.getTimes(dd, [root.latitude, root.longitude], root.timezone);
        var times = getPrayersPreParsed(rawtimes);
        var nnext = getNext(time, times);
        root.data.next = {
            prayer: nnext[0],
            remaining: getRemaining(nnext[1]),
            time: nnext[1],
            symbol: symbols[nnext[0]]
        }
        root.data.table = getPrayersParsed(times);
    }

    function getNext(time, obj){

        var next = "null";
        var arr = Object.values(obj);
        var i = 0;
        for(var i=0; i<arr.length; i++){
            if(time<arr[i].replace(":","")){
                next = arr[i];
                break;
            }
        }
        if(next === "null"){
            return [Object.keys(obj)[0], arr[0]];
        }
        return [Object.keys(obj)[i], next, symbols[Object.keys(obj)[i]]];
    }

    function getRemaining(e) {
        const now = new Date();
        let diff = ((e.split(':').map(Number).reduce((a,b)=>a*60+b) 
                    - now.getHours()*60 - now.getMinutes() + 1440) % 1440);

        const h = diff / 60 ^ 0;
        const m = diff % 60;

        return h ? `${h.toString().padStart(2,0)}h:${m.toString().padStart(2,0)}m`
                : `${m.toString().padStart(2,0)}m`;
    }

    function getPrayersPreParsed(rawTimes){
        const filtred = Object.keys(rawTimes).reduce((acc, key) => {
            if (rawTimes[key] !== "-----") {
                acc[key] = rawTimes[key];
            }
            return acc;
        }, {});
        const sorted = {};
        for (const key of Object.keys(filtred).sort((a, b) => +filtred[a].replace(":","") - +filtred[b].replace(":",""))) {
            sorted[key] = filtred[key];
        }
        return sorted;
    }

    function getPrayersParsed(prayers){
        const arr = Object.entries(prayers).map(([pray, time]) => ({ pray, time, symbol:symbols[pray] }))
        return arr
    }

    Component.onCompleted: {
        if (!root.gpsActive) return;
        console.info("[PrayerService] Starting the GPS service.");
        positionSource.start();
    }

    Timer {
        running: !root.gpsActive
        repeat: true
        interval: root.fetchInterval
        triggeredOnStart: !root.gpsActive
        onTriggered: root.getData()
    }

}
