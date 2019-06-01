Rebol [
    Title: "Rebol PWA"
    Version: "0.1.0"
    ThemeColor: "#FFFFFF"
]

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
