pragma Singleton
import QtQuick

QtObject {
    readonly property string clientId: "35485"
    readonly property string redirectUri: "myapp://anilist-auth"  // Custom URI scheme
    readonly property string authUrl: "https://anilist.co/api/v2/oauth/authorize"
    readonly property string tokenUrl: "https://anilist.co/api/v2/oauth/pin"
    readonly property string scope: ""
}