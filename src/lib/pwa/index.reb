Rebol [
    Title: "Rebol PWA"
    Version: "0.1.0"
    ThemeColor: "#FFFFFF"
    DebugLevel: 10
    IncludeVID: true
]

init: func [] [
    view layout [
        title "Title"
        h1 "Heading 1"
        h2 "Heading 2"
        h3 "Heading 3"
        h4 "Heading 4"
        h5 "Heading 5"
        banner "Banner"
        vh1 "Video Heading 1"
        vh2 "Video Heading 2"
        vh3 "Video Heading 3"
        vtext "Video Body Text"
        label "Label"
    ]
]

init