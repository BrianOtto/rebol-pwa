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
        
        |
        
        'guide
            (vjs-style-guide id)
    ] ]
    
    id
]

vjs-layout-id: 0

vjs-init
