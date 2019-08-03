Rebol [
    Title: "Rebol PWA"
    Version: "0.1.1"
    ThemeColor: "#FFFFFF"
    DebugLevel: 10
    IncludeVID: true
]

init: func [] [
    view layout [
        tabs 40
        field "Field 1"
        field "Field 2"
        field "Field 3"
        return
        across
        tabs 100
        button "Button 1"
        button "Button 2"
        button "Button 3"
    ]
]

init