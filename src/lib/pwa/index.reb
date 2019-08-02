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
        tabs 80
        text "Name"  tab field return
        text "Email" tab field return
        text "Phone" tab field return
    ]
]

init