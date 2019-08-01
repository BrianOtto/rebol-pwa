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

vjs-style-below: js-native [
    enable [integer!]
    ret [integer!]
] {
    var enable = reb.UnboxInteger(reb.ArgR('enable'))
    var ret = reb.UnboxInteger(reb.ArgR('ret'))
    
    if (enable == 1) {
        window.vjsBelow = true
    } else {
        window.vjsBelow = false
    }
    
    if (ret == 1) {
        window.vjsReturn = true
    }
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
        ] set text text! 
            (vjs-style-text id to text! style text)
        
        |
        
        'across
            (vjs-style-below 0 0)
        
        |
        
        'below
            (vjs-style-below 1 0)
        
        |
        
        'return
            (vjs-style-below 1 1)
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
    ]
]

init