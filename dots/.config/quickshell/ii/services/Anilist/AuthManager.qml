pragma Singleton
pragma ComponentBehavior: Bound


import Quickshell
import Quickshell.Io
import QtQuick
import QtPositioning
import qs.modules.common
import Qt.labs.platform

Singleton {
    id: root
    
    property string accessToken: "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6ImQzNjI2ODc3MzVjNDdkZjAzMzBmODA4NGVmMTAyMDJkMTRlMjY3YzQ4ZTRiOWQ4MWQ3ZGNkNDQ3YjllMTZjMGQ0MDMxY2RkOWIzNjNlZGM5In0.eyJhdWQiOiIzNTQ4NSIsImp0aSI6ImQzNjI2ODc3MzVjNDdkZjAzMzBmODA4NGVmMTAyMDJkMTRlMjY3YzQ4ZTRiOWQ4MWQ3ZGNkNDQ3YjllMTZjMGQ0MDMxY2RkOWIzNjNlZGM5IiwiaWF0IjoxNzcwMDc5MjI3LCJuYmYiOjE3NzAwNzkyMjcsImV4cCI6MTgwMTYxNTIyNywic3ViIjoiNTc4MzM1NyIsInNjb3BlcyI6W119.onNb5LyPFtqliUCCnZyt5lsAXhG3XdLHRjjZs0xjmfEXlCqM3MLYgBUdVvItLw7A2RX6Pj3SjMmOPBWaQUAf3sXkLRoDaSaJwlBtSsJbXhDlCeL1mkAy2lYQMYdd_ggKfiPDz_hnOjsFm2b79O7_7CCOF12urfEPazyQiADoAeFaz4QbTktn_Trwf7a1QIPzkUMC9u2e8NHCL84104W-T2e7Smu9cr5RCcLRvilDjE2DCCV97zi2BKHNGG3wXceCYWHOXTbqKaX7x_EoXiEOkrdZL1YEBrBiEixPqGY3tRu3xrlGVGcJpmHjTBHVwaDxrmvAu8aSzBfXFA0xrn3RdBJZp9utNMPghlQwdZkXXGoqQDTqTnMnuWFqM-xA7FA7cQ9lchDnAyhsKZtBfdnCq1eAX8Mlzp0sLDs0hv99_mUKcubB3rd_nrM6TDLL4R37vr72S3i5yYC7UQFGjdpvwqlkhggp0YrSXWDgOOfIsiv8ixs-bH_HVyUv7M6F3BLkNQYZxo00-3LEbNnNUFkI3qDrW4z0BMq68dByXbzyppSqGEuR0XmDnDOd_5qeP1k1kEs05wAgf81KEexbvYzjkpmssDm0dsbtJ75pQbsDq8ultJCublS21HROKRSUinc2Ch8k1suxje-6-xS3DlYR1HQs3UHfYFVMkHMT3xELeuY"
    property bool authenticated: false
    property string name: "adenlall"
    property string id: "5783357"
    
    readonly property string authUrl: AuthConfig.authUrl + 
        "?client_id=" + AuthConfig.clientId +
        "&response_type=token"
    
    function authenticate() {
        Qt.openUrlExternally(authUrl)
    }
    
    
    function getUserId(authCode) {
        var xhr = new XMLHttpRequest()
        xhr.open("POST", AuthConfig.tokenUrl)
        xhr.setRequestHeader("Content-Type", "application/json")
        xhr.setRequestHeader("Accept", "application/json")
        xhr.setRequestHeader("Authorization", accessToken)
        
        var data = {
            grant_type: "authorization_code",
            client_id: AuthConfig.clientId,
            client_secret: "YOUR_CLIENT_SECRET",
            code: authCode
        }
        
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 200) {
                    var response = JSON.parse(xhr.responseText)
                    console.log("Token received successfully")
                    
                    accessToken = response.access_token
                    refreshToken = response.refresh_token
                    authenticated = true
                    
                    // Save tokens securely
                    saveTokens()
                    
                    // Emit signal
                    authenticationSuccessful()
                } else {
                    console.error("Token exchange failed:", xhr.status, xhr.responseText)
                    authenticationFailed()
                }
            }
        }
        
        xhr.send(JSON.stringify(data))
    }
    
    // Save tokens to secure storage
    function saveTokens() {
        // Use Qt.labs.settings or your preferred storage
        settings.setValue("anilist/access_token", accessToken)
        settings.setValue("anilist/refresh_token", refreshToken)
    }
    
    // Load saved tokens
    function loadTokens() {
        accessToken = settings.value("anilist/access_token", "")
        refreshToken = settings.value("anilist/refresh_token", "")
        authenticated = accessToken !== ""
    }
    
    // Refresh access token
    function refreshAccessToken() {
        if (!refreshToken) return
        
        var xhr = new XMLHttpRequest()
        xhr.open("POST", AuthConfig.tokenUrl)
        xhr.setRequestHeader("Content-Type", "application/json")
        
        var data = {
            grant_type: "refresh_token",
            client_id: AuthConfig.clientId,
            client_secret: "YOUR_CLIENT_SECRET",
            refresh_token: refreshToken
        }
        
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 200) {
                    var response = JSON.parse(xhr.responseText)
                    accessToken = response.access_token
                    refreshToken = response.refresh_token
                    saveTokens()
                } else {
                    // Refresh failed - user needs to re-authenticate
                    authenticated = false
                    accessToken = ""
                    refreshToken = ""
                }
            }
        }
        
        xhr.send(JSON.stringify(data))
    }
    
    // Logout
    function logout() {
        accessToken = ""
        refreshToken = ""
        authenticated = false
        settings.remove("anilist/access_token")
        settings.remove("anilist/refresh_token")
    }
    
    signal authenticationSuccessful()
    signal authenticationFailed(string error)
}