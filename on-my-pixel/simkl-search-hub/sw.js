// Simkl Search Hub service worker. Bump VERSION whenever you push changes.
const VERSION = 'v9';
const CACHE_PREFIX = 'simkl-search-hub-';
const SHELL = CACHE_PREFIX + 'shell-' + VERSION;
const FONTS = CACHE_PREFIX + 'fonts-v1';
const ASSETS = ['./', './index.html', './manifest.json', './icon-192.png', './icon-512.png'];

self.addEventListener('install', e => {
  e.waitUntil(
    caches.open(SHELL)
      .then(c => Promise.allSettled(ASSETS.map(a => c.add(a)))) // a missing file won't break install
      .then(() => self.skipWaiting())
  );
});

self.addEventListener('activate', e => {
  e.waitUntil(
    caches.keys()
      .then(keys => Promise.all(keys.filter(k => k.startsWith(CACHE_PREFIX) && k !== SHELL && k !== FONTS).map(k => caches.delete(k))))
      .then(() => self.clients.claim())
  );
});

self.addEventListener('fetch', e => {
  const req = e.request;
  if (req.method !== 'GET') return;
  const url = new URL(req.url);

  // Google Fonts: serve from cache, refresh in background
  if (url.hostname === 'fonts.googleapis.com' || url.hostname === 'fonts.gstatic.com') {
    e.respondWith(
      caches.open(FONTS).then(async cache => {
        const hit = await cache.match(req);
        const net = fetch(req).then(r => { if (r.ok || r.type === 'opaque') cache.put(req, r.clone()); return r; }).catch(() => hit);
        return hit || net;
      })
    );
    return;
  }

  if (url.origin !== location.origin) return;

  // Pages: network first so fresh pushes show up, cache as the offline fallback.
  // ignoreSearch lets /?title=...&year=... still open offline.
  if (req.mode === 'navigate') {
    e.respondWith(
      fetch(req)
        .then(async r => { const cache = await caches.open(SHELL); await cache.put('./index.html', r.clone()).catch(() => {}); return r; })
      .catch(() => caches.open(SHELL).then(c => c.match(req, { ignoreSearch: true }).then(r => r || c.match('./index.html'))))
    );
    return;
  }

  // Other same-origin files: cached copy now, refreshed in background
  e.respondWith(
    caches.open(SHELL).then(async cache => {
      const hit = await cache.match(req);
      const net = fetch(req).then(async r => { if (r.ok) await cache.put(req, r.clone()).catch(() => {}); return r; }).catch(() => hit);
      return hit || net;
    })
  );
});
