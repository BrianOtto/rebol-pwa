var runRebol
var pwaLoaded = false
var debug = true

Module = {}
Module['print'] = function(msg) { log(msg) }

if ('serviceWorker' in navigator) {
    navigator.serviceWorker.register('worker.js')
    .then(function() {
        log('Rebol PWA - Service Worker Registered')
        log('Rebol PWA - Loading Ren-C')
        
        var libr3 = document.createElement('script')
        libr3.src = 'js/libr3.js'
        
        document.head.appendChild(libr3)
        
        loadPWA()
    })
    .catch(error => {
        log('Rebol PWA - Service Worker Failed\n' + error)
    })
} else {
    log('Your browser does not support service workers.')
}

var loadPWA = function() {
    if (typeof runDependencyWatcher === 'undefined' || runDependencyWatcher !== null) {
        setTimeout(loadPWA, 100)
    } else {
        Promise.resolve()
        .then(function() {
            log('Rebol PWA - Ren-C Startup')
            
            reb.Startup()
            
            log('Rebol PWA - Ren-C System Path')
            
            reb.Elide(
                'change-dir system/options/path: as url!',
                reb.T('/')
            )
            
            log('Rebol PWA - Ren-C Extensions')
            
            reb.Elide(
                'for-each collation builtin-extensions',
                '[load-extension collation]'
            )
            
            log('Rebol PWA - Loading pwa.reb')
            
            return fetch('pwa.reb')
            .then(function(response) {
                return response.text()
            })
            .then(function(text) {
                log('Rebol PWA - Running pwa.reb')
                
                reb.Elide(text)
                
                log('Rebol PWA - Ren-C Console')
                
                setTimeout(loadApp, 100)
                
                return reb.Promise('pwa-main')
            })
        })
    }
}

var loadApp = function() {
    if (pwaLoaded !== true) {
        setTimeout(loadApp, 100)
    } else {
        log('Rebol PWA - Loading index.reb')
        
        return fetch('index.reb')
        .then(function(response) {
            return response.text()
        })
        .then(function(text) {
            log('Rebol PWA - Running index.reb')
            
            runRebol(text.replace(/Rebol \[[^\]]*\]/, ''))
        })
    }
}

var log = function(msg) {
    if (debug && window.console) { console.log(msg) }
}