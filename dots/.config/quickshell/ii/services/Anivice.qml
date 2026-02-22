pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import qs.modules.common

Singleton {
    id: root

    readonly property string clientId: "35485"
    readonly property string redirectUri: "https://anilist.co/api/v2/oauth/pin"
    readonly property string authUrl:"https://anilist.co/api/v2/oauth/authorize"+"?client_id="+clientId+"&response_type=token"

    property string accessToken: Config.options.bar.anime.api_token
    property int userId: Config.options.bar.anime.id ?? 0
    property string name: Config.options.bar.anime.name ?? ""

    function openAuth() {
        Qt.openUrlExternally(authUrl)
    }
    
    function auth() {
        tk = Config.options.bar.anime.api_token
        id = Config.options.bar.anime.id
        if(!tk||tk.length<10||!id) return false
        return true
    }

    function saveToken() {
        var tk = Config.options.bar.anime.api_token

        if (!tk || tk.length < 10) {
            Quickshell.execDetached(["notify-send", 
                Translation.tr("Anime"), 
                Translation.tr("Not a valid token!")
                , "-a", "Shell"
            ])
            Config.options.bar.anime.auth = false
            return
        }
        accessToken = tk
        fetchViewer()
    }


    function fetchViewer() {
        const str = 'query{Viewer{id name}}'
        query(str).then(data => {
            Quickshell.execDetached(["notify-send", 
                Translation.tr("Anime"),
                Translation.tr("Welecome "+data.Viewer.name+"! your sucessfully in.")
                , "-a", "Shell"
            ])
            Config.options.bar.anime.auth = true
            storeUserData(accessToken,data.Viewer.id,data.Viewer.name)
        })
    }


    function getUserWatching() {
        return query(
            "query($id: Int) { MediaListCollection(userId: $id, type: ANIME, sort: [UPDATED_TIME_DESC]) { lists { name entries { media { nextAiringEpisode { airingAt episode } title { userPreferred } coverImage { large } bannerImage genres } } } } }",
            {
                id:userId
            }
          )
    }

    function storeUserData(token, id, name) {
        Config.options.bar.anime.api_token = token
        Config.options.bar.anime.id = id
        Config.options.bar.anime.name = name
        accessToken = token
        userId = id
        name = name
    }

    function logout() {
        Config.options.bar.anime.api_token = ""
        Config.options.bar.anime.id = 0
        Config.options.bar.anime.name = ""
        accessToken = ""
        userId = 0
        name = ""
    }



    function query(queryString, variables) {
        return new Promise(function(resolve, reject) {

            var xhr = new XMLHttpRequest()
            xhr.open("POST", "https://graphql.anilist.co")
            xhr.setRequestHeader("Content-Type", "application/json")
            xhr.setRequestHeader("Accept", "application/json")
            xhr.setRequestHeader("Authorization", accessToken)
            
            var data = {
                query: queryString,
                variables: variables || {}
            }
            
            xhr.onreadystatechange = function() {
                if (xhr.readyState === XMLHttpRequest.DONE) {
                    if (xhr.status === 200) {
                        try {
                            var response = JSON.parse(xhr.responseText)
                            if (response.errors) {
                                reject(response.errors)
                            } else {
                                resolve(response.data)
                            }
                        } catch (e) {
                            reject("Failed to parse response")
                        }
                    } else {
                        Quickshell.execDetached(["notify-send", 
                            Translation.tr("Anime"), 
                            Translation.tr("Authentication failed! Go to Settings -> Services -> Anime and fix it")
                            , "-a", "Shell"
                        ])
                        Config.options.bar.anime.auth = false
                    }
                }
            }
            xhr.send(JSON.stringify(data))
        })
    }

    function isoTimeParse(timestamp){
        var date = new Date(Number(timestamp) * 1000); // Convert to milliseconds

        const year = date.getUTCFullYear();
        const month = String(date.getUTCMonth() + 1).padStart(2, '0'); // Months are 0-based
        const day = String(date.getUTCDate()).padStart(2, '0');
        const hours = String(date.getUTCHours()).padStart(2, '0');
        const minutes = String(date.getUTCMinutes()).padStart(2, '0');
        const seconds = String(date.getUTCSeconds()).padStart(2, '0');

        return `${year}-${month}-${day}T${hours}:${minutes}:${seconds}Z`;
    }
    function getRemainingTime(rawTime){
        var parsed = isoTimeParse(rawTime);
        const targetDate = new Date(parsed);
    
        const now = new Date();
        
        const diffMs = targetDate - now;
        if (diffMs <= 0) {
            return { 
                hasPassed: true,
                message: "The target date has already passed."
            };
        }
        
        const diffSeconds = Math.floor(diffMs / 1000);
        const diffMinutes = Math.floor(diffSeconds / 60);
        const diffHours = Math.floor(diffMinutes / 60);
        const diffDays = Math.floor(diffHours / 24);
        
        const remainingHours = diffHours % 24;
        const remainingMinutes = diffMinutes % 60;
        
        return {
            totalDays: diffDays,
            totalHours: diffHours,
            totalMinutes: diffMinutes,
            totalSeconds: diffSeconds,
            totalMs: diffMs,
            formatted: `${diffDays} days, ${remainingHours}h:${remainingMinutes}m`,
            isFuture: true
        };

    }
    
}
