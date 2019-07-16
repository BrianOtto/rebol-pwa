delete-dir: func [source] [
    for-each file read source [
        either find file "/" [
            delete-dir source/:file
            delete source/:file
        ][
            delete source/:file
        ]
    ]
]

copy-dir: func [source dest] [
    if not exists? dest [make-dir/deep dest]
    
    for-each file read source [
        either find file "/" [
            copy-dir source/:file dest/:file
        ][
            write dest/:file read source/:file
        ]
    ]
]

get-cache-urls: func [source] [
    for-each file read source [
        either find file "/" [
            get-cache-urls source/:file
        ][
            if source/:file != %web/manifest.json [
                url: to text! source/:file
                insert cache-urls replace url "web/" "./"
            ]
        ]
    ]
]

print "^/Building PWA ..."

delete-dir %web/

copy-dir %src/lib/pwa/ %web/
copy-dir %app/ %web/

make-dir %web/js

html: to text! read %src/index.html

if not attempt [
    data: load/header %web/index.reb
    
    headerTitle: (first data)/title
    if any [empty? headerTitle headerTitle == "Untitled"] [1 / 0]
    
    headerVersion: (first data)/version
    if empty? headerVersion [1 / 0]
    
    headerThemeColor: (first data)/themecolor
    if empty? headerThemeColor [1 / 0]
    
    replace html "%title%" headerTitle
    replace/all html "%version%" headerVersion
    replace html "%theme-color%" headerThemeColor
    
    write %web/index.html html
][
    print "^/You have an invalid Rebol header in /app/index.reb"
    print "It must have the following minimum fields."
    
    prin {
    e.g.

    Rebol ^(5B)
        Title: "Rebol PWA"
        Version: "0.1.0"
        ThemeColor: "#FFFFFF"
    ^(5D)
    }
    
    quit
]

js: to text! read %src/index.js

attempt [
    headerDebugLevel: (first data)/debuglevel
    
    ; TODO: add support for various debug levels, e.g.
    ; 10 = Info / 20 = Warning / 30 = Error / 40 = Critical
    if headerDebugLevel >= 10 [
        replace js "var debug = false" "var debug = true"
    ]
]

write %web/js/index.js js

write %web/js/libr3.js read %src/lib/ren-c/libr3.js

index-web: to text! read %web/index.reb
index-src: to text! read %src/index.reb

write %web/index.reb unspaced [index-web "^/" index-src]

worker-lib: to text! read %src/lib/ren-c/libr3.worker.js
worker-src: to text! read %src/worker.js

cache-name: lowercase replace headerTitle " " "-"
cache-name: unspaced [cache-name "-" headerVersion]
replace worker-src "%cache-name%" cache-name

cache-urls: [%./]
cache-urls-string: "^/"
get-cache-urls %web/
reverse cache-urls

for-each url cache-urls [
    append cache-urls-string unspaced ["^(tab)'" url "',^/"] 
]

replace worker-src "%cache-urls%" cache-urls-string

write %web/worker.js unspaced [worker-lib "^/" worker-src]

print "^/Done"
print "^/You can run the application by pointing a web server to"

current-dir: what-dir

if system/version/4 == 3 [
    current-dir: copy next current-dir
    replace/all current-dir "/" "\"
    replace current-dir "\" ":\"
]

print unspaced ["^/" current-dir "web"]