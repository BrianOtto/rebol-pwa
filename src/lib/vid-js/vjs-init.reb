vjs-init: js-native [] {
    window.vjsLayouts = []
    window.vjsCSS = document.createElement('link')
    window.vjsBelow = false
    window.vjsReturn = false
    window.vjsCols = 1
    window.vjsRows = 1
    
    window.vjsAddElement = function(id, element) {
        div = document.createElement('div')
        
        if (window.vjsBelow) {
            window.vjsCols = 1
            window.vjsRows++
            
            if (window.vjsReturn) {
                window.vjsBelow = false
            }
        }
        
        window.vjsReturn = false
        
        div.style.gridRowStart = window.vjsRows
        div.style.gridColumnStart = window.vjsCols
        
        div.appendChild(element)
        
        if (window.vjsLayouts[id] == null) {
            window.vjsLayouts[id] = document.createDocumentFragment()
        }
        
        window.vjsLayouts[id].appendChild(div)
        
        window.vjsCols++
    }
    
    window.vjsCSS.rel  = 'stylesheet'
    window.vjsCSS.type = 'text/css'
    window.vjsCSS.href = 'css/vjs.css'
    
    document.querySelector('head').appendChild(window.vjsCSS)
}
