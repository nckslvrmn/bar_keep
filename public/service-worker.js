const CACHE_NAME = 'bar-keep-v4';
const MAX_IMAGE_CACHE_SIZE = 50;
const MAX_CACHE_AGE_MS = 7 * 24 * 60 * 60 * 1000;

const urlsToCache = [
    '/manifest.json',
    '/icon.svg',
    '/icon-192.png',
    '/icon-512.png',
    '/icon-180.png',
    '/icon-152.png',
    '/icon-120.png',
    '/offline.html'
];

// Paths that should NEVER be cached (auth, mutations)
const EXCLUDED_PATHS = [
    '/login',
    '/logout',
    '/sessions',
    '/users',
    '/admin'
];

// Paths allowed for offline viewing (read-only)
const OFFLINE_VIEWABLE_PATHS = [
    '/',
    '/items'
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

    // Only handle GET requests
    if (request.method !== 'GET') return;

    // Never cache authentication or admin pages
    if (EXCLUDED_PATHS.some(path => url.pathname.startsWith(path))) {
        return;
    }

    // Never cache requests with CSRF tokens (mutations)
    if (url.pathname.includes('authenticity_token') ||
        request.headers.get('X-CSRF-Token')) {
        return;
    }

    // Check if this is an offline-viewable path
    const isOfflineViewable = OFFLINE_VIEWABLE_PATHS.some(path =>
        url.pathname === path || url.pathname.startsWith(path)
    );

    // Check if this is an image request
    const isImage = request.destination === 'image' ||
        /\.(jpg|jpeg|png|gif|webp|svg)$/i.test(url.pathname);

    event.respondWith(
        caches.match(request)
            .then(response => {
                // Return cached response if available
                if (response) {
                    return response;
                }

                // Try to fetch from network
                const fetchRequest = request.clone();

                return fetch(fetchRequest).then(response => {
                    // Don't cache invalid responses
                    if (!response || response.status !== 200 || response.type !== 'basic') {
                        return response;
                    }

                    // Don't cache responses that set cookies (auth changes)
                    if (response.headers.get('Set-Cookie')) {
                        return response;
                    }

                    const contentType = response.headers.get('Content-Type') || '';
                    const isHTML = contentType.includes('text/html');

                    // Cache strategy:
                    // 1. Cache images for offline viewing
                    // 2. Cache items index page for offline viewing
                    // 3. Cache CSS/JS assets
                    if (isImage ||
                        (isHTML && isOfflineViewable) ||
                        contentType.includes('css') ||
                        contentType.includes('javascript')) {

                        const responseToCache = response.clone();

                        caches.open(CACHE_NAME)
                            .then(cache => {
                                cache.put(request, responseToCache);

                                if (isImage) {
                                    cache.keys().then(keys => {
                                        const imageKeys = keys.filter(k =>
                                            k.url.match(/\.(jpg|jpeg|png|gif|webp|svg)$/i)
                                        );

                                        if (imageKeys.length > MAX_IMAGE_CACHE_SIZE) {
                                            const keysToDelete = imageKeys.slice(0, imageKeys.length - MAX_IMAGE_CACHE_SIZE);
                                            return Promise.all(keysToDelete.map(key => cache.delete(key)));
                                        }
                                    });
                                }
                            });
                    }

                    return response;
                }).catch(() => {
                    // Offline fallback
                    if (request.destination === 'document') {
                        // If requesting an offline-viewable page, try to serve from cache
                        if (isOfflineViewable) {
                            return caches.match(request).then(cached => {
                                return cached || caches.match('/offline.html');
                            });
                        }
                        return caches.match('/offline.html');
                    }

                    // Return cached image if available
                    if (isImage) {
                        return caches.match(request);
                    }
                });
            })
    );
});
