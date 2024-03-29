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

vjs-style-text: js-native [
    id [integer!]
    style [text!]
    text [text!]
    width [integer!]
    height [integer!]
]{
    var id = reb.UnboxInteger(reb.ArgR('id'))
    var style = reb.Spell(reb.ArgR('style'))
    var text = reb.Spell(reb.ArgR('text'))
    var width = reb.UnboxInteger(reb.ArgR('width'))
    var height = reb.UnboxInteger(reb.ArgR('height'))
    
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
        
        if (width > 0) {
            element.style.width = width + 'px';
            
            if (height > 0) {
                element.style.height = height + 'px';
            }
        }
        
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
    width [integer!]
    height [integer!]
]{
    var id = reb.UnboxInteger(reb.ArgR('id'))
    var style = reb.Spell(reb.ArgR('style'))
    var text = reb.Spell(reb.ArgR('text'))
    var width = reb.UnboxInteger(reb.ArgR('width'))
    var height = reb.UnboxInteger(reb.ArgR('height'))
    
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
    
    // subtract the padding and border sizes
    width = width - 6
    height = height - 6
    
    if (width > 0) {
        element.style.width = width + 'px';
        
        if (height > 0) {
            element.style.height = height + 'px';
        }
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
    var id = reb.UnboxInteger(reb.ArgR('id'))
    
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
    width [integer!]
    height [integer!]
] {
    var id = reb.UnboxInteger(reb.ArgR('id'))
    var width = reb.UnboxInteger(reb.ArgR('width'))
    var height = reb.UnboxInteger(reb.ArgR('height'))
    
    element = document.createElement('div')
    
    if (width > 0) {
        element.style.width = width + 'px';
        
        if (height > 0) {
            element.style.height = height + 'px';
        }
    }
    
    vjsAddElement(id, element)
}
view: js-native [
    id [integer!]
]{
    var id = reb.UnboxInteger(reb.ArgR('id'))
    
    if (typeof window.vjsLayouts[id] != 'undefined') {
        document.querySelector('#app').appendChild(window.vjsLayouts[id])
        
        // HACK: adjust the elements to align with any tab stops they have
        // This should be replaced with a proper grid system in the new version
        if (window.vjsTabs.length > 0) {
            // TODO: make these configurable
            // It is the app's default margin
            var totalWidth  = 10
            var totalHeight = 10
            
            document.querySelectorAll('#app > div, #app > br').forEach((parent) => {
                parent.querySelectorAll('div, br').forEach((element) => {
                    if (element.nodeName == 'DIV') {
                        var pushA = 0
                        var pushB = 0
                        
                        if (element.hasAttribute('vjs-tab-a')) {
                            pushA = parseInt(element.getAttribute('vjs-tab-a'), 10) - totalWidth
                            
                            if (pushA > 0) {
                                element.style.marginLeft = pushA + 'px'
                            }
                        } else if (element.hasAttribute('vjs-tab-b')) {
                            pushB = parseInt(element.getAttribute('vjs-tab-b'), 10) - totalHeight
                            
                            if (pushB > 0) {
                                element.style.marginTop = pushB + 'px'
                            }
                        }
                        
                        totalWidth  += parseInt(window.getComputedStyle(element).width, 10) + pushA
                        totalHeight += parseInt(window.getComputedStyle(element).height, 10) + pushB
                    } else {
                        totalWidth  = 10
                        totalHeight = 10
                    }
                })
                
                if (parent.nodeName == 'BR') {
                    totalWidth  = 10
                    totalHeight = 10
                }
            })
        }
    }
}

layout: func [
    specs [block!]
][
    vjs-layout-id: me + 1
    id: vjs-layout-id
    
    vjs-style-reset
    
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
        ]
        
        opt set text text!
        opt set size [integer! | pair!]
        opt set color tuple!
        opt set align word!
        
            (
            
            width: 0
            height: 0
            
            either pair? size [
                width: size/1
                height: size/2
            ][
                width: size
            ]
            
            vjs-style-text id to text! style text width height
            
            vjs-style-reset
            
            )
        
        |
        
        copy style [
              'field  ; <input type="text">
            | 'info   ; <input type="text" readonly>
            | 'button ; <input type="button">
        ]
        
        opt set text text!
        opt set size [integer! | pair!]
        opt set color tuple!
        opt set align word!
        
            (
            
            width: 0
            height: 0
            
            either pair? size [
                width: size/1
                height: size/2
            ][
                width: size
            ]
            
            vjs-style-field id to text! style text width height
            
            vjs-style-reset
            
            )
            
        |
        
        'across
            (vjs-style-across 1)
        
        |
        
        'below
            (vjs-style-across 0)
        
        |
        
        'return
            (vjs-style-return id)
        
        |
        
        'tabs set size integer!
            (vjs-style-tabs-clear)
            (vjs-style-tabs size)
        
        |
        
        'tabs set sizes block!
            (vjs-style-tabs-clear)
            (for-each size sizes [vjs-style-tabs size])
        
        |
        
        'tab
            (vjs-style-tab)
        
        |
        
        'guide
        
        opt set size [integer! | pair!]
        
            (
            
            width: 0
            height: 0
            
            either pair? size [
                width: size/1
                height: size/2
            ][
                width: size
            ]
            
            vjs-style-guide id width height
            
            vjs-style-reset
            
            )
        
        |
        
        skip
    ] ]
    
    id
]

vjs-layout-id: 0

vjs-style-reset: func [] [
    text: ""
    size: 0
    color: 0.0.0
    align: 'left
]

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
        vh2 "Guides"
        guide 60x100
        label "Name:" 100x24 right
        field
        return
        label "Address:" 100x24 right
        field
        return
    ]
]

init