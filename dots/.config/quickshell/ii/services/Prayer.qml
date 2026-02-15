pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Io
import QtQuick
import QtPositioning
import qs.modules.common

import "Praytime.js" as PrayTimeModule


Singleton {
    id: root
    readonly property int fetchInterval: Config.options.bar.prayer.fetchInterval * 60000 // x*minute
    readonly property real latitude: Config.options.bar.prayer.latitude
    readonly property real longitude: Config.options.bar.prayer.longitude
    readonly property real timezone: Config.options.bar.prayer.timezone
    readonly property real timezone_auto: Config.options.bar.prayer.timezone_auto
    property var prayTime: new PrayTimeModule.PrayTime("ISNA")
    
    readonly property bool imsak    : Config.options.bar.prayer.prayerControl.imsak
    readonly property bool fajr     : Config.options.bar.prayer.prayerControl.fajr
    readonly property bool sunrise  : Config.options.bar.prayer.prayerControl.sunrise
    readonly property bool dhuhr    : Config.options.bar.prayer.prayerControl.dhuhr
    readonly property bool asr      : Config.options.bar.prayer.prayerControl.asr
    readonly property bool sunset   : Config.options.bar.prayer.prayerControl.sunset
    readonly property bool maghrib  : Config.options.bar.prayer.prayerControl.maghrib
    readonly property bool isha     : Config.options.bar.prayer.prayerControl.isha
    readonly property bool midnight : Config.options.bar.prayer.prayerControl.midnight

    readonly property string configHash: JSON.stringify({
        imsak:root.imsak,
        fajr:root.fajr,
        sunrise:root.sunrise,
        dhuhr:root.dhuhr,
        asr:root.asr,
        sunset:root.sunset,
        maghrib:root.maghrib,
        isha:root.isha,
        midnight:root.midnight
    })

    onConfigHashChanged: {
        root.getData()
    }

    onLatitudeChanged: {
        root.getData();
    }
    onTimezoneChanged: {
        root.getData();
    }
    onLongitudeChanged: {
        root.getData();
    }
    onTimezone_autoChanged: {
        root.getData();
    }

    property var symbols: ({ // prayer icons
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
        lastRefresh:'',
        next:{
            prayer:'',      // prayer name
            remaining:'',   // remaining time for the prayer
            time:'',        // time witch the prayer srart
            symbol:''       // the icon that represent the prayer
        },
        table:[]            // all prayer of the day ex: [{pray:"Asr", time:"23:00", symbol:"sun"},...]
    })

    function getData() {
        const newDate = new Date();
        const time = newDate.getHours()+""+newDate.getMinutes();
        var rawPrayerTimes = prayTime.getTimes(newDate, [root.latitude, root.longitude], root.timezone_auto ? 'auto' : root.timezone);
        var prayerTimes = getPrayersPreParsed(rawPrayerTimes);
        var nnext = getNext(time, prayerTimes);
        root.data = {
            lastRefresh:DateTime.time + " • " + DateTime.date,
            next:{
                prayer: nnext[0],
                remaining: getRemaining(nnext[1]),
                time: nnext[1],
                symbol: symbols[nnext[0]]
            },
            table:getPrayersParsed(prayerTimes)
        }
    }

    function getNext(time, obj){

        var next = "null";
        var arr = Object.values(obj);
        var i = 0;
        for(var i=0; i<arr.length; i++){
            if(time<arr[i].replace(":","")){
                next = arr[i];
                if (Math.abs(time-arr[i].replace(":","")) <= 2){
                    Audio.playSystemSound("alarm-clock-elapsed")
                    Quickshell.execDetached(["notify-send", 
                        Translation.tr("Prayer : "+Object.keys(obj)[i]),
                        Translation.tr("The Prayer is now at : "+next)
                        , "-a", "Shell"
                    ]);
                }
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
            if (Config.options.bar.prayer.prayerControl[key]) {
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

    Timer {
        running: true
        repeat: true
        interval: root.fetchInterval
        triggeredOnStart: true
        onTriggered: root.getData()
    }

}
