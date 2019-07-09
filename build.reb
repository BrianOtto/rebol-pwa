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

print "^/Building PWA ..."

delete-dir %web/

copy-dir %src/lib/pwa/ %web/
copy-dir %app/ %web/

make-dir %web/js

write %web/js/libr3.js read %src/lib/ren-c/libr3.js

worker-src: to text! read %src/lib/ren-c/libr3.worker.js
worker-web: to text! read %web/worker.js

write %web/worker.js unspaced [worker-src "^/" worker-web]

index-web: to text! read %web/index.reb
index-src: to text! read %src/index.reb

write %web/index.reb unspaced [index-web "^/" index-src]

html: to text! read %src/index.html
data: load/header %web/index.reb

replace html "%title%" (first data)/title
replace/all html "%version%" (first data)/version
replace html "%theme-color%" (first data)/themecolor

write %web/index.html html
write %web/js/index.js read %src/index.js

print "^/Done"
print "^/You can run the application by pointing a web server to"

current-dir: what-dir

if system/version/4 == 3 [
    current-dir: copy next current-dir
    replace/all current-dir "/" "\"
    replace current-dir "\" ":\"
]

print unspaced ["^/" current-dir "web"]