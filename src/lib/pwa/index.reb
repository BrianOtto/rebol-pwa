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