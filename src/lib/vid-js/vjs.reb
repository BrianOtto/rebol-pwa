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