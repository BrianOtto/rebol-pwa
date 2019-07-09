lib-js: to text! read %libr3.js
lib-js-mem: read %libr3.js.mem
lib-wasm: read %libr3.wasm

; TODO: replace all Atomics.wake calls with Atomics.notify

uri-base64: "data:application/octet-stream;base64,"
replace lib-js "libr3.js.mem" unspaced [uri-base64 enbase lib-js-mem]
replace lib-js "libr3.wasm" unspaced [uri-base64 enbase lib-wasm]
replace lib-js "libr3.worker.js" "../worker.js"

write %libr3.js lib-js

delete %libr3.js.mem
delete %libr3.wasm