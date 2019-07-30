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
