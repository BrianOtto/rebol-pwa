vjs-init: js-native [] {
    window.vjsLayouts = []
    window.vjsCSS = document.createElement('link')
    
    window.vjsAcross = true
    window.vjsReturn = false
    window.vjsTabs = []
    window.vjsTabsIndex = 0
    window.vjsTab = false
    
    window.vjsAddElement = function(id, element) {
        if (window.vjsLayouts[id] == null) {
            window.vjsLayouts[id] = document.createDocumentFragment()
        }
        
        if (window.vjsAcross == false) {
            var br = document.createElement('br')
            window.vjsLayouts[id].appendChild(br)
        }
        
        var div = document.createElement('div')
        
        if (window.vjsTab) {
            var tabAttribute = (window.vjsAcross) ? 'vjs-tab-a' : 'vjs-tab-b'
            div.setAttribute(tabAttribute, window.vjsTabs[window.vjsTabsIndex])
            
            if (window.vjsTabsIndex == window.vjsTabs.length - 1) {
                window.vjsTabsIndex = 0
            } else {
                window.vjsTabsIndex++
            }
            
            window.vjsTab = false
        }
        
        div.appendChild(element)
        
        window.vjsLayouts[id].appendChild(div)
        
        if (window.vjsReturn) {
            window.vjsAcross = !window.vjsAcross
            window.vjsReturn = false
        }
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

vjs-style-tabs: js-native [
    size [integer!]
] {
    var size = reb.UnboxInteger(reb.ArgR('size'))
    window.vjsTabs.push(size)
}

vjs-style-tabs-clear: js-native [] {
    window.vjsTabs = []
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
            break
        case 'button' :
            element = document.createElement('input')
            element.type = 'button'
            element.value = text
    }
    
    vjsAddElement(id, element)
}

vjs-style-tab: js-native []{
    window.vjsTab = true
}
view: js-native [
    id [integer!]
]{
    var id = reb.Spell(reb.ArgR('id'))
    
    if (typeof window.vjsLayouts[id] != 'undefined') {
        document.querySelector('#app').appendChild(window.vjsLayouts[id])
        
        // HACK: adjust the elements to align with any tab stops they have
        // This should be replaced with a proper grid system in the new version
        if (window.vjsTabs.length > 0) {
            // TODO: make these configurable
            // It is the app's default margin
            var totalWidth  = 10
            var totalHeight = 10
            
            document.querySelectorAll('#app > div, #app > br').forEach((element) => {
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
        }
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
        ]
        
        opt set text text! 
        
            (vjs-style-text id to text! style text)
            (text: "")
        
        |
        
        copy style [
              'field  ; <input type="text">
            | 'info   ; <input type="text" readonly>
            | 'button ; <input type="button">
        ]
        
        opt set text text!
        opt set width integer!
        
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
        tabs [80 350]
        h2 "Line 1"
        tab field
        tab field
        return
        tabs 50
        tab h3 "Line 2"
        tabs [80 350]
        tab text "Check"
        tab button "Ok"
        return
        h4 "Line 3"
        tab button "Button 1"
        tab button "Button 2"
    ]
]

init