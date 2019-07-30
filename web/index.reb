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

vid-style-h1: js-native [
    id [integer!]
    text [text!]
]{
    var id = reb.Spell(reb.ArgR('id'))
    var text = reb.Spell(reb.ArgR('text'))
    
    element = document.createElement('h1')
    element.textContent = text
    
    vidAddElement(id, element)
}

vid-style-h2: js-native [
    id [integer!]
    text [text!]
]{
    var id = reb.Spell(reb.ArgR('id'))
    var text = reb.Spell(reb.ArgR('text'))
    
    element = document.createElement('h2')
    element.textContent = text
    
    vidAddElement(id, element)
}

view: js-native [
    id [integer!]
]{
    var id = reb.Spell(reb.ArgR('id'))
    
    document.querySelector('#app').appendChild(window.vidLayouts[id])
}

layout: func [
    specs [block!]
][
    vid-layout-id: me + 1
    id: vid-layout-id
    
    parse specs rules: [ any [
        'h1 set text text! 
            (vid-style-h1 id text)
        
        |
        
        'h2 set text text! 
            (vid-style-h2 id text)
        
        |
    ] ]
    
    id
]

vid-layout-id: 0

vid-init

Rebol [
    Title: "Rebol PWA"
    Version: "0.1.0"
    ThemeColor: "#FFFFFF"
    DebugLevel: 10
    IncludeVID: true
]

init: func [] [
    view layout [
        h1 "Hello"
        h2 "World"
    ]
]

init