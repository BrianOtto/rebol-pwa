vjs-init: js-native [] {
    window.vjsLayouts = []
    window.vjsCSS = document.createElement('link')
    
    window.vjsAcross = false
    window.vjsReturn = false
    
    window.vjsTabs = []
    window.vjsTabsIndex = 0
    window.vjsTabsMulti = 1
    window.vjsTab = false
    
    window.vjsAddElement = function(id, element) {
        if (window.vjsLayouts[id] == null) {
            window.vjsLayouts[id] = document.createDocumentFragment()
            
            var div = document.createElement('div')
            window.vjsLayouts[id].appendChild(div)
        }
        
        var div = document.createElement('div')
        
        if (window.vjsTab) {
            var tabAttribute = (window.vjsAcross) ? 'vjs-tab-a' : 'vjs-tab-b'
            var tabSize = window.vjsTabs[window.vjsTabsIndex] * window.vjsTabsMulti
            div.setAttribute(tabAttribute, tabSize)
            
            if (window.vjsTabsIndex == window.vjsTabs.length - 1) {
                window.vjsTabsIndex = 0
                window.vjsTabsMulti++
            } else {
                window.vjsTabsIndex++
            }
            
            window.vjsTab = false
        }
        
        div.appendChild(element)
        
        window.vjsLayouts[id].lastChild.appendChild(div)
        
        if (window.vjsReturn) {
            window.vjsAcross = !window.vjsAcross
            window.vjsReturn = false
        } else if (window.vjsAcross == false) {
            var br = document.createElement('br')
            window.vjsLayouts[id].lastChild.appendChild(br)
        }
    }
    
    window.vjsCSS.rel  = 'stylesheet'
    window.vjsCSS.type = 'text/css'
    window.vjsCSS.href = 'css/vjs.css'
    
    document.querySelector('head').appendChild(window.vjsCSS)
}
