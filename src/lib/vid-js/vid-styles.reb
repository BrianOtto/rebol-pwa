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
