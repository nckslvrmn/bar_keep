const CACHE_NAME = 'bar-keep-v2';
const urlsToCache = [
    '/manifest.json',
    '/icon.svg',
    '/icon-192.png',
    '/offline.html'
];

const EXCLUDED_PATHS = [
    '/login',
    '/logout',
    '/sessions',
    '/users',
    '/items',
    '/admin'
];

self.addEventListener('install', event => {
    event.waitUntil(
        caches.open(CACHE_NAME)
            .then(cache => cache.addAll(urlsToCache))
            .then(() => self.skipWaiting())
    );
});

self.addEventListener('activate', event => {
    event.waitUntil(
        caches.keys().then(cacheNames => {
            return Promise.all(
                cacheNames.map(cacheName => {
                    if (cacheName !== CACHE_NAME) {
                        return caches.delete(cacheName);
                    }
                })
            );
        }).then(() => self.clients.claim())
    );
});

self.addEventListener('fetch', event => {
    const { request } = event;
    const url = new URL(request.url);

    if (request.method !== 'GET') return;

    if (EXCLUDED_PATHS.some(path => url.pathname.startsWith(path))) {
        return;
    }

    if (request.headers.get('Accept')?.includes('text/html') &&
        !url.pathname.includes('offline.html')) {
        return;
    }

    if (url.pathname.includes('authenticity_token') ||
        request.headers.get('X-CSRF-Token')) {
        return;
    }

    event.respondWith(
        caches.match(request)
            .then(response => {
                if (response) {
                    return response;
                }

                const fetchRequest = request.clone();

                return fetch(fetchRequest).then(response => {
                    if (!response || response.status !== 200 || response.type !== 'basic') {
                        return response;
                    }

                    if (response.headers.get('Set-Cookie')) {
                        return response;
                    }

                    const contentType = response.headers.get('Content-Type') || '';
                    if (contentType.includes('text/html')) {
                        return response;
                    }

                    const responseToCache = response.clone();

                    caches.open(CACHE_NAME)
                        .then(cache => {
                            cache.put(request, responseToCache);
                        });

                    return response;
                });
            })
            .catch(() => {
                if (request.destination === 'document') {
                    return caches.match('/offline.html');
                }
            })
    );
});
