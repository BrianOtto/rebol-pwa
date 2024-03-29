; moving the pwa prompt code here temporarily
; this needs to be refactored into the VID-JS API
vjs-prompt: js-native [] {
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