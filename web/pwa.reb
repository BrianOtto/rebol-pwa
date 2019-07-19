; Ren-C Interface

read: function [
    source [any-value!]
][
    pwa-main-read to text! source
]

write-stdout: function [
    text [text! char!]
][
    if char? text [text: my to-text]
    trim/with text ">>"
    
    pwa-main-write text
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
    read
    write-stdout
    read-stdin
]

; Rebol PWA

pwa-main-read: js-awaiter [
    return: [binary!]
    url [text!]
]{
    let url = reb.Spell(reb.ArgR('url'))
    
    let response = await fetch(url, { cache: 'no-store' })
    let buffer = await response.arrayBuffer()
    
    return reb.Binary(buffer)
}

pwa-main-write: js-awaiter [
    msg [text!]
]{
    log(reb.Spell(reb.ArgR('msg')))
}

pwa-main: adapt 'console [ pwa-main-loaded ]
pwa-main-loaded: js-native [] { pwaLoaded = true }

pwa-load: load: js-awaiter [
    url [text! file! url!]
] {
    let url = reb.Spell(reb.ArgR('url'))
    
    log('Rebol PWA - Loading ' + url)
    
    return new Promise(function(resolve, reject) {
        fetch(url)
        .then(function(response) {
            return response.text()
        })
        .then(function(rebol) {
            log('Rebol PWA - Running ' + url, true)
            
            reb.Elide(rebol)
            
            resolve()
        })
        .catch(function(error) {
            reject(error)
        })
    })
}