vid-init: js-native [] {
    window.vidLayouts = []
    
    window.vidAddElement = function(id, element) {
        if (window.vidLayouts[id] == null) {
            window.vidLayouts[id] = document.createDocumentFragment()
        }
        
        window.vidLayouts[id].appendChild(element)
    }
}
