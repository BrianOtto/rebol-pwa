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

; remove the Rebol [] header, otherwise reb.Elide() will fail
; load/mold does not preserve formatting and so we use parse instead

; TODO: Look into preserving the header by using something other  
;       than reb.Elide() to run the code. This will allow apps 
;       access to it and we can get rid of the mess below

data: to text! read %web/index.reb
data-with-no-header: ""

parse data ["Rebol [" thru "]" copy data-with-no-header to end]
replace/all data-with-no-header "^M^M" "^M"

write %web/index.reb data-with-no-header

print "^/Done"
print "^/You can run the application by pointing a web server to"

current-dir: what-dir

if system/version/4 == 3 [
    current-dir: copy next current-dir
    replace/all current-dir "/" "\"
    replace current-dir "\" ":\"
]

print unspaced ["^/" current-dir "web"]