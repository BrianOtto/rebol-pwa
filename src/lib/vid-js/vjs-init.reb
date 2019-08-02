vjs-init: js-native [] {
    window.vjsLayouts = []
    window.vjsCSS = document.createElement('link')
    
    window.vjsAcross = true
    window.vjsReturn = false
    window.vjsTabs = 0
    
    window.vjsAddElement = function(id, element) {
        if (window.vjsLayouts[id] == null) {
            window.vjsLayouts[id] = document.createDocumentFragment()
        }
        
        if (window.vjsAcross == false) {
            var br = document.createElement('br')
            window.vjsLayouts[id].appendChild(br)
        }
        
        if (window.vjsReturn) {
            window.vjsAcross = !window.vjsAcross
            window.vjsReturn = false
        }
        
        var div = document.createElement('div')
        div.appendChild(element)
        
        window.vjsLayouts[id].appendChild(div)
    }
    
    window.vjsCSS.rel  = 'stylesheet'
    window.vjsCSS.type = 'text/css'
    window.vjsCSS.href = 'css/vjs.css'
    
    document.querySelector('head').appendChild(window.vjsCSS)
}
