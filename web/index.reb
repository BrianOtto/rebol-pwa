vjs-init: js-native [] {
    window.vjsLayouts = []
    window.vjsCSS = document.createElement('link')
    
    window.vjsAcross = true
    window.vjsReturn = false
    
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

vjs-style-across: js-native [
    enable [integer!]
] {
    var enable = reb.UnboxInteger(reb.ArgR('enable'))
    
    if (enable == 1) {
        window.vjsAcross = true
    } else {
        window.vjsAcross = false
    }
}

vjs-style-return: js-native [] {
    window.vjsAcross = !window.vjsAcross
    window.vjsReturn = true
}

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
    }
    
    vjsAddElement(id, element)
}
view: js-native [
    id [integer!]
]{
    var id = reb.Spell(reb.ArgR('id'))
    
    if (typeof window.vjsLayouts[id] != 'undefined') {
        document.querySelector('#app').appendChild(window.vjsLayouts[id])
    }
}

layout: func [
    specs [block!]
][
    vjs-layout-id: me + 1
    id: vjs-layout-id
    
    parse specs rules: [ any [
        copy style [
              'title  ; <h1>
            | 'h1     ; <h2>
            | 'h2     ; <h3>
            | 'h3     ; <h4>
            | 'h4     ; <h5>
            | 'h5     ; <h6>
            | 'banner ; <h1 class="vjs-banner">
            | 'vh1    ; <h2 class="vjs-vh1">
            | 'vh2    ; <h3 class="vjs-vh2">
            | 'vh3    ; <h4 class="vjs-vh3">
            | 'text   ; <span>
            | 'txt    ; <span>
            | 'vtext  ; <span class="vjs-vtext">
            | 'tt     ; <code>
            | 'code   ; <code class="vjs-code">
            | 'label  ; <span class="vjs-label">
        ] opt set text text! 
            (vjs-style-text id to text! style text)
            (text: "")
        
        |
        
        copy style [
              'field  ; <input type="text">
            | 'info   ; <input type="text" readonly>
        ] opt set text text! 
            (vjs-style-field id to text! style text)
            (text: "")
            
        |
        
        'across
            (vjs-style-across 1)
        
        |
        
        'below
            (vjs-style-across 0)
        
        |
        
        'return
            (vjs-style-return)
    ] ]
    
    id
]

vjs-layout-id: 0

vjs-init

Rebol [
    Title: "Rebol PWA"
    Version: "0.1.1"
    ThemeColor: "#FFFFFF"
    DebugLevel: 10
    IncludeVID: true
]

init: func [] [
    view layout [
        across
        title "Title"
        h1 "Heading 1"
        h2 "Heading 2"
        return
        h3 "Heading 3"
        h4 "Heading 4"
        h5 "Heading 5"
        below
        banner "Banner"
        vh1 "Video Heading 1"
        vh2 "Video Heading 2"
        vh3 "Video Heading 3"
        vtext "Video Body Text"
        label "Label"
        field
        field "Your Name"
        info
        info "First Last"
    ]
]

init