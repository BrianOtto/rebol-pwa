Rebol [
    Title: "Rebol PWA"
    Version: "0.1.0"
    ThemeColor: "#FFFFFF"
    DebugLevel: 10
]

init: js-native [] {
    // TODO: move this into the src/lib/vid-js library
    
    var doc = document.querySelector('body')
    doc.style.margin = '10px'
    
    var div = document.createElement('div')
    div.style.justifyContent = 'center'
    div.style.display = 'flex'
    
    var button = document.createElement('button')
    button.innerHTML = 'Install Rebol PWA'
    button.id = 'pwaButton'
    button.disabled = true
    
    button.onclick = function() {
        pwaPrompt.prompt()
        
        pwaPrompt.userChoice
        .then((choice) => {
            if (choice.outcome === 'accepted') {
                pwaIsInstalled()
            }
            
            pwaPrompt = null
        })
    }
    
    div.appendChild(button)
    doc.appendChild(div)
    
    pwaCheckPrompt = function() {
        var pwaButton = document.querySelector('#pwaButton')
        
        if (window.matchMedia('(display-mode: standalone)').matches) {
            pwaIsInstalled()
        } else {
            // TODO: set an install flag in local storage 
            //       and check for this before looping
            if (pwaPrompt === null) {
                setTimeout(pwaCheckPrompt, 100)
            } else {
                pwaButton.disabled = false
            }
        }
    }
     
    pwaIsInstalled = function() {
        var pwaButton = document.querySelector('#pwaButton')
        
        pwaButton.innerHTML = 'Rebol PWA is installed'
        pwaButton.style.background = '#FFF'
        pwaButton.style.border = '1px solid #000'
        pwaButton.style.outline = 'none'
        pwaButton.style.padding = '10px'
        
        pwaButton.onclick = null
        pwaButton.disabled = false
    }
    
    pwaCheckPrompt()
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