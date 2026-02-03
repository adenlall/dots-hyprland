import QtQuick

QtObject {
    id: client
    
    property string apiUrl: "https://graphql.anilist.co"
    
    function query(queryString, variables) {
        return new Promise(function(resolve, reject) {
            if (!authManager.authenticated) {
                reject("Not authenticated")
                return
            }
            
            var xhr = new XMLHttpRequest()
            xhr.open("POST", apiUrl)
            xhr.setRequestHeader("Content-Type", "application/json")
            xhr.setRequestHeader("Accept", "application/json")
            xhr.setRequestHeader("Authorization", authManager.accessToken)
            
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
                    } else if (xhr.status === 401) {
                        authManager.refreshAccessToken()
                        reject("Unauthorized - token expired")
                    } else {
                        reject("HTTP error: " + xhr.status)
                    }
                }
            }
            
            xhr.send(JSON.stringify(data))
        })
    }
    
    function getUserInfo() {
        var query = `
            query {
                Viewer {
                    id
                    name
                    avatar {
                        large
                    }
                }
            }
        `
        
        return query(query)
    }
}