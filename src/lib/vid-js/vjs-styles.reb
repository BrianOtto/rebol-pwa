vjs-style-text: js-native [
    id [integer!]
    style [text!]
    text [text!]
]{
    var id = reb.Spell(reb.ArgR('id'))
    var style = reb.Spell(reb.ArgR('style'))
    var text = reb.Spell(reb.ArgR('text'))
    
    var tag = ''
    var cls = false
    
    switch (style) {
        case 'title' :
        case 'banner' :
            tag = 'h1'
            break
        case 'h1' :
        case 'vh1' :
            tag = 'h2'
            break
        case 'h2' :
        case 'vh2' :
            tag = 'h3'
            break
        case 'h3' :
        case 'vh3' :
            tag = 'h4'
            break
        case 'h4' :
            tag = 'h5'
            break
        case 'h5' :
            tag = 'h6'
            break
        case 'text' :
        case 'txt' :
        case 'vtext' :
        case 'label' :
            tag = 'span'
            break
        case 'tt' :
        case 'code' :
            tag = 'code'
    }
    
    switch (style) {
        case 'banner' :
        case 'vh1' :
        case 'vh2' :
        case 'vh3' :
        case 'text' :
        case 'txt' :
        case 'vtext' :
        case 'code' :
        case 'label' :
            cls = true
    }
    
    if (tag != '') {
        element = document.createElement(tag)
        element.textContent = text
        
        if (cls) {
            element.className = 'vjs-' + style
        }
        
        vjsAddElement(id, element)
    }
}

vjs-style-field: js-native [
    id [integer!]
    style [text!]
    text [text!]
]{
    var id = reb.Spell(reb.ArgR('id'))
    var style = reb.Spell(reb.ArgR('style'))
    var text = reb.Spell(reb.ArgR('text'))
    
    switch (style) {
        case 'field' :
            element = document.createElement('input')
            element.type = 'text'
            element.value = text
            break
        case 'info' :
            element = document.createElement('input')
            element.type = 'text'
            element.disabled = true
            element.value = text
            break
        case 'button' :
            element = document.createElement('input')
            element.type = 'button'
            element.value = text
    }
    
    vjsAddElement(id, element)
}

vjs-style-across: js-native [
    enable [integer!]
]{
    var enable = reb.UnboxInteger(reb.ArgR('enable'))
    
    if (enable == 1) {
        window.vjsAcross = true
    } else {
        window.vjsAcross = false
    }
    
    window.vjsReturn = false
    
    window.vjsTabsIndex = 0
    window.vjsTabsMulti = 1
}

vjs-style-return: js-native [
    id [integer!]
] {
    var id = reb.Spell(reb.ArgR('id'))
    
    window.vjsAcross = !window.vjsAcross
    window.vjsReturn = true
    
    window.vjsTabsIndex = 0
    window.vjsTabsMulti = 1
    
    if (window.vjsLayouts[id]) {
        var br = document.createElement('br')
        window.vjsLayouts[id].appendChild(br)
        
        var div = document.createElement('div')
        window.vjsLayouts[id].appendChild(div)
    }
}

vjs-style-tabs: js-native [
    size [integer!]
]{
    var size = reb.UnboxInteger(reb.ArgR('size'))
    window.vjsTabs.push(size)
}

vjs-style-tabs-clear: js-native [] {
    window.vjsTabs = []
}

vjs-style-tab: js-native [] {
    window.vjsTab = true
}

vjs-style-guide: js-native [
    id [integer!]
] {
    var id = reb.Spell(reb.ArgR('id'))
    
    element = document.createElement('div')
    vjsAddElement(id, element)
}