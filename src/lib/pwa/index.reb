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
        vh2 "Guides"
        guide 60x100
        label "Name:" 100x24 right
        field
        return
        label "Address:" 100x24 right
        field
        return
    ]
]

init