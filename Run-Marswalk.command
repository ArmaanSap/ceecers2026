#!/usr/bin/env bash
cd "$(dirname "$0")"
PORT=8123
(sleep 2; (xdg-open "http://localhost:$PORT/" || open "http://localhost:$PORT/") >/dev/null 2>&1) &
if command -v node >/dev/null; then node scripts/serve.mjs $PORT; else python3 -m http.server $PORT --bind 127.0.0.1 --directory dist; fi
