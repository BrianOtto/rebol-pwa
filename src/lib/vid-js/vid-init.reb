vid-init: js-native [] {
    window.vidLayouts = []
    window.vidCSS = document.createElement('link')
    
    window.vidAddElement = function(id, element) {
        div = document.createElement('div')
        div.appendChild(element)
        
        if (window.vidLayouts[id] == null) {
            window.vidLayouts[id] = document.createDocumentFragment()
        }
        
        window.vidLayouts[id].appendChild(div)
    }
    
    window.vidCSS.rel  = 'stylesheet'
    window.vidCSS.type = 'text/css'
    window.vidCSS.href = 'css/vid.css'
    
    document.querySelector('head').appendChild(window.vidCSS)
}
