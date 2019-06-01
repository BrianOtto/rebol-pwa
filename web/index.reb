

init: js-native [] {
    // TODO: move this into the src/lib/vid-js library
    
    var pwaPrompt
    
    var button = document. createElement('button')
    button.style.margin = 'margin: 0 auto'
    button.innerHTML = 'Install Rebol PWA'
    button.disabled = true
    
    button.click = function() {
        pwaPrompt.prompt()
    }
    
    document.querySelector('body').appendChild(button)
    
    // TODO: why is this event is not firing
    window.addEventListener('beforeinstallprompt', function (event) {
        e.preventDefault()
        pwaPrompt = event
        
        button.disabled = false
    })
}

init

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
    
    ; TODO: look into stripping the extra whitespace
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
    log [text!]
]{
    let log = reb.Spell(reb.ArgR('log'))
    
    if (debug === true) {
        console.log(log)
    }
}

pwa-main: adapt 'console []