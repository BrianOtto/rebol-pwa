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
    ] ]
    
    id
]

vid-layout-id: 0

vid-init
