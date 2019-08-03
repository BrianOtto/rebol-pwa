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
        tabs 150
        vh3 "Buttons:"
        tab
        button "Button 1"
        tab
        button "Button 2"
    ]
]

init