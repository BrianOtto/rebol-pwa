var runRebol
var pwaLoaded = false

var debug = true
var debugTmp = false

if ('serviceWorker' in navigator) {
    navigator.serviceWorker.register('worker.js')
    .then(function() {
        log('Rebol PWA - Service Worker Registered')
        log('Rebol PWA - Loading Ren-C')
        
        var libr3 = document.createElement('script')
        libr3.src = 'js/libr3.js'
        
        document.head.appendChild(libr3)

        libr3IsLoaded = function() {
            if (typeof runDependencyWatcher === 'undefined' || runDependencyWatcher !== null) {
                setTimeout(libr3IsLoaded, 100)
            } else {
                Promise.resolve(null)
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
                        
                        debugTmp = debug
                        debug = false
                        
                        setTimeout(loadApp, 100)
                        
                        return reb.Promise('pwa-main')
                    })
                    .then(function(text) {
                        console.log('yoyo')
                    })
                })
                .then(function() {
                    
                })
            }
        }

        libr3IsLoaded()
    })
    .catch(error => {
        log('Rebol PWA - Service Worker Failed\n' + error)
    })
} else {
    log('Your browser does not support service workers.')
}

var loadApp = function(msg, force) {
    if (pwaLoaded) {
        debug = debugTmp
        debugTmp = false
        
        log('Rebol PWA - Loading vid.reb')
        
        fetch('vid.reb')
        .then(function(response) {
            return response.text()
        })
        .then(function(text) {
            log('Rebol PWA - Running vid.reb')
            
            //runRebol(text)
            
            log('Rebol PWA - Loading index.reb')
            
            return fetch('index.reb')
            .then(function(response) {
                return response.text()
            })
            .then(function(text) {
                log('Rebol PWA - Running index.reb')
                
                runRebol(text.replace(/Rebol \[[^\]]*\]/s, ''))
            })
        })
    } else {
        setTimeout(loadApp, 100)
    }
}

var log = function(msg, force) {
    if ((debug || force) && window.console) { console.log(msg) }
}