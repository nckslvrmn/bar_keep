const CACHE_NAME = 'bar-keep-v1';
const urlsToCache = [
    '/',
    '/manifest.json',
    '/icon.svg',
    '/icon-192.png',
    '/offline.html'
];

// Paths that should never be cached
const EXCLUDED_PATHS = [
    '/login',
    '/logout',
    '/sessions',
    '/users'
];

// Install event - cache assets
self.addEventListener('install', event => {
    event.waitUntil(
        caches.open(CACHE_NAME)
            .then(cache => cache.addAll(urlsToCache))
            .then(() => self.skipWaiting())
    );
});

// Activate event - clean up old caches
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

// Fetch event - serve from cache, fallback to network
self.addEventListener('fetch', event => {
    const { request } = event;
    const url = new URL(request.url);

    // Skip non-GET requests
    if (request.method !== 'GET') return;

    // Skip authentication-related paths
    if (EXCLUDED_PATHS.some(path => url.pathname.startsWith(path))) {
        return;
    }

    // Skip requests with session tokens or CSRF tokens
    if (url.pathname.includes('authenticity_token') ||
        request.headers.get('X-CSRF-Token')) {
        return;
    }

    event.respondWith(
        caches.match(request)
            .then(response => {
                // Cache hit - return response
                if (response) {
                    return response;
                }

                // Clone the request
                const fetchRequest = request.clone();

                return fetch(fetchRequest).then(response => {
                    // Check if valid response
                    if (!response || response.status !== 200 || response.type !== 'basic') {
                        return response;
                    }

                    // Don't cache responses that set cookies
                    if (response.headers.get('Set-Cookie')) {
                        return response;
                    }

                    // Clone the response
                    const responseToCache = response.clone();

                    // Add to cache
                    caches.open(CACHE_NAME)
                        .then(cache => {
                            cache.put(request, responseToCache);
                        });

                    return response;
                });
            })
            .catch(() => {
                // Offline fallback for navigation requests
                if (request.destination === 'document') {
                    return caches.match('/offline.html');
                }
            })
    );
});
