var cacheName = '%cache-name%'
var cacheURLs = [%cache-urls%]

// a new service worker is installing
// cache our URLs for offline usage 
this.addEventListener('install', event => {
    event.waitUntil(
        caches.open(cacheName).then(cache => cache.addAll(cacheURLs))
    )
})

// a new service worker has completed installing
// delete the cache the previous worker was using
this.addEventListener('activate', event => {
    event.waitUntil(
        caches.keys()
        .then(keys => 
            Promise.all(
                keys
                .filter(key => key !== cacheName)
                .map(key => caches.delete(key))
            )
        )
    )
})

// capture all URL requests
this.addEventListener('fetch', function(event) {
    event.respondWith(
        // does it exist in our cache
        caches.match(event.request)
        .then(response => {
            if (response) {
                // return the cached version
                return response
            } else {
                // fetch the URL and cache it
                return fetch(event.request)
                .then(response => {
                    return caches.open(cacheName)
                    .then(cache => {
                        cache.put(event.request, response.clone())
                        return response
                    })
                    .catch(error => {
                        console.log('Rebol PWA - Cache failed for ' + event.request.url)
                        return response
                    })
                })
                .catch(error => {
                    console.log('Rebol PWA - Fetch failed for ' + event.request.url)
                })
            }
        })
    )
})