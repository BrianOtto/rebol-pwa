; Ren-C Interface

write-stdout: function [
    text [text! char!]
][
    if char? text [text: my to-text]
    
    if not any [
        empty? trim text
        find/match text "Welcome to Rebol"
        find/match text ">>"
        find/match text "=="
    ][
        pwa-main-stdout text
    ]
]

read-stdin: js-awaiter [
    return: [text!]
]{
    return new Promise(function(resolve, reject) {
        runRebol = function(text) {
            resolve(reb.Text(text))
        }
    })
}

sys/export [
    write-stdout
    read-stdin
]

; Rebol PWA

pwa-main-stdout: js-awaiter [
    msg [text!]
]{
    log(reb.Spell(reb.ArgR('msg')))
}

pwa-main: adapt 'console [ pwa-main-loaded ]
pwa-main-loaded: js-native [] { pwaLoaded = true }

load: js-awaiter [
    url [text! file! url!]
]{
    let url = reb.Spell(reb.ArgR('url'))
    
    log('Rebol PWA - Loading ' + url)
    
    return new Promise(function(resolve, reject) {
        fetch(url)
        .then(function(response) {
            return response.text()
        })
        .then(function(text) {
            log('Rebol PWA - Running ' + url)
            
            reb.Elide(text)
            
            resolve()
        })
        .catch(function(error) {
            reject(error)
        })
    })
}