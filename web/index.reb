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

vid-style-below: js-native [
    enable [integer!]
    ret [integer!]
] {
    var enable = reb.UnboxInteger(reb.ArgR('enable'))
    var ret = reb.UnboxInteger(reb.ArgR('ret'))
    
    if (enable == 1) {
        window.vidBelow = true
    } else {
        window.vidBelow = false
    }
    
    if (ret == 1) {
        window.vidReturn = true
    }
}

vid-style-text: js-native [
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
            element.className = 'vid-' + style
        }
        
        vidAddElement(id, element)
    }
}

view: js-native [
    id [integer!]
]{
    var id = reb.Spell(reb.ArgR('id'))
    
    if (typeof window.vidLayouts[id] != 'undefined') {
        document.querySelector('#app').appendChild(window.vidLayouts[id])
    }
}

layout: func [
    specs [block!]
][
    vid-layout-id: me + 1
    id: vid-layout-id
    
    parse specs rules: [ any [
        copy style [
              'title  ; <h1>
            | 'h1     ; <h2>
            | 'h2     ; <h3>
            | 'h3     ; <h4>
            | 'h4     ; <h5>
            | 'h5     ; <h6>
            | 'banner ; <h1 class="vid-banner">
            | 'vh1    ; <h2 class="vid-vh1">
            | 'vh2    ; <h3 class="vid-vh2">
            | 'vh3    ; <h4 class="vid-vh3">
            | 'text   ; <span>
            | 'txt    ; <span>
            | 'vtext  ; <span class="vid-vtext">
            | 'tt     ; <code>
            | 'code   ; <code class="vid-code">
            | 'label  ; <span class="vid-label">
        ] set text text! 
            (vid-style-text id to text! style text)
        
        |
        
        'across
            (vid-style-below 0 0)
        
        |
        
        'below
            (vid-style-below 1 0)
        
        |
        
        'return
            (vid-style-below 1 1)
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