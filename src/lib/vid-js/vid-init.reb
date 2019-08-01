vid-init: js-native [] {
    window.vidLayouts = []
    window.vidCSS = document.createElement('link')
    window.vidBelow = false
    window.vidReturn = false
    window.vidCols = 1
    window.vidRows = 1
    
    window.vidAddElement = function(id, element) {
        div = document.createElement('div')
        
        if (window.vidBelow) {
            window.vidCols = 1
            window.vidRows++
            
            if (window.vidReturn) {
                window.vidBelow = false
            }
        }
        
        window.vidReturn = false
        
        div.style.gridRowStart = window.vidRows
        div.style.gridColumnStart = window.vidCols
        
        div.appendChild(element)
        
        if (window.vidLayouts[id] == null) {
            window.vidLayouts[id] = document.createDocumentFragment()
        }
        
        window.vidLayouts[id].appendChild(div)
        
        window.vidCols++
    }
    
    window.vidCSS.rel  = 'stylesheet'
    window.vidCSS.type = 'text/css'
    window.vidCSS.href = 'css/vid.css'
    
    document.querySelector('head').appendChild(window.vidCSS)
}
