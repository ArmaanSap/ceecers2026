# Marswalk

A Jezero Crater mission planner for NASA Space Apps: choose a round-trip distance, mission time, and scientific activities; generate a route along the recorded Perseverance traverse; explore historical Mastcam-Z panoramas on screen or through WebXR.

## Quick start (Windows)
Double-click `Run-Marswalk.bat`. It starts a local server (Node.js or Python, whichever is installed) and opens http://localhost:8123/ . macOS/Linux: `./Run-Marswalk.command`. The 3D terrain and fonts need an internet connection; the 2D map, planner, simulator logic and panoramas work from the bundled data.

## Walking simulator, points, feed and log
See `docs/SIMULATOR.md`. Slope pathfinding runs in labelled placeholder mode until a real DEM is supplied: `docs/PATHFINDING.md`. Optional browser check: `python3 scripts/browser-smoke.py` (needs Playwright and Chrome).

## Run the app locally

Requires Python 3. No frontend installation or build is needed to view the app.

```sh
python3 -m http.server 8000 --directory dist
```

Open http://localhost:8000. Do not double-click index.html: ES modules and JSON fetches require HTTP. Cached NASA images, panoramas and route geometry are included. Live ODE requests require internet and may be blocked by CORS; cached product catalogs remain available. VR requires an HTTPS host when accessed from Quest Browser; a computer's plain HTTP LAN address will not work for headset VR.

## Contents

- `dist/index.html`, `style.css`, `app.js`: interface, planner integration and source catalog.
- `dist/routing.js`: Mars distances, graph construction, Dijkstra search, greedy itinerary selection and panorama sequencing.
- `dist/map-camera.js`: global-to-local map camera and coordinate conversions.
- `dist/vr.js`: native WebXR cylindrical panorama renderer and controller navigation.
- `dist/assets/`: cached Jezero imagery, global MOLA relief, 29 panoramas, traverse/waypoint JSON, source metadata and orbital-product catalogs.
- `scripts/`: preparation, archive generation and automated tests.
- `docs/`: routing, data sources, maintenance and known limitations.
- `.openai/hosting.json`: current hosting configuration; contains the Site identifier, not credentials.
- `.githooks/pre-commit`: archive freshness safeguard.
- `ARCHIVE-MANIFEST.json` (inside downloaded ZIP): included paths, sizes, SHA-256 hashes and source fingerprint.

## Tests and archive updates

Requires Node.js with ES modules and Python 3.

```sh
npm test
npm run bundle
npm run verify:bundle
npm run watch:zip
```

`watch:zip` updates the local ZIP as files change while that process is running. `npm run build` runs tests, rebuilds and verifies the archive for release. Enable the additional Git safeguard with `git config core.hooksPath .githooks`.

The website's About → Download project ZIP always points to the archive packaged with the currently published site. Each publication replaces it. An already downloaded ZIP does not change on your computer; download again to get the latest release. Unpublished editor changes are not available from the hosted download.

## Reproduce or refresh data

The bundled snapshot runs without refreshing datasets. Data preparation uses optional Python dependencies in requirements.txt. `scripts/prepare_global.py` rebuilds global MOLA context. `scripts/fetch_catalogs.py` refreshes bounded ODE catalog queries. `scripts/prepare_data.py --input-dir inputs` is the original local-data preparation workflow; it requires `inputs/waypoints.json`, `inputs/traverse.json`, and `inputs/panos.html` obtained from the original sources in docs/DATA-SOURCES.md. It may need adaptation if those providers change their formats. Do not treat dataset refresh as a safe substitute for scientific validation.

## Quest 2

Open the published HTTPS website directly in Meta Quest Browser, open a panorama, and select Enter VR. Right trigger: next; left trigger: previous; either grip: exit. The images are monoscopic cylindrical photographs with approximate vertical framing, not a navigable 3D reconstruction. Automated renderer/session tests use mocks; physical Quest 2 validation is outstanding.

## Scope

This archive contains the project's current source, bundled assets, tests and documentation. It does not contain the entire NASA/PDS archives, browser-local user settings, Git history, credentials, or unimplemented future datasets. NASA and partner image credits remain in the app and source metadata. No blanket license is granted here over third-party imagery.

## Arrival, color map and base
The orbital fly-in starts automatically, with an automatic reverse-CRT point → line → screen animation and no Power on button. It blends into the color Jezero map before the map docks and the side panels appear. Reduced-motion users get short fades. Music is attempted automatically; browsers that block autoplay start it on the first normal pointer or keyboard interaction. There is no separate music opt-in.

The default map is the FU Berlin Jezero colorized mosaic: HiRISE/CTX detail pan-sharpened with HRSC color (ESA/DLR/FU Berlin and NASA/JPL-Caltech/UArizona/USGS). The B&W source remains available as a map layer. This is colorized multi-instrument imagery, not native full-resolution RGB photography. Preparation and exact map bounds are recorded in scripts/prepare_color.py and assets/color-source.json.

All routes depart from and return to **Martian Base**, a fictional planning base at the recorded Rose River Falls panorama location (id 17). The configuration is in dist/mission-base.js and is included in mission exports. Old saved departure choices are ignored. No real human base exists at this location.

Location metadata, equipment/simulation and music attribution are expandable to keep the planner concise. Automated checks cover fixed-base round trips, routing, map/globe geometry, VR handling and automatic-intro failure recovery. Browser visual/GPU and physical Quest 2 testing remain unverified.

## Mission selection
The left settings sidebar is replaced by a right-side picker. Choose Crater floor, Delta edge or Upper traverse; confirm the region; then select task buttons and confirm each addition. Tasks can be removed through the same prompt. Build mission calculates a round trip from Martian Base using only science stops in the confirmed region. Travel to/from the region can pass through other regions along the recorded rover network. These are interface groupings of recorded panoramas, not official geological boundaries. Time/distance controls remain in an expandable panel.

POIs are accessible dot buttons over the map. Hover or keyboard focus shows name, short description and a panorama action; tapping a dot pins the bubble. Labels stay inside map edges. Panoramas retain their original metadata and historical-position caveats. The old side detail bar is not part of the new main layout.

## Esri terrain and alternative routes
3D terrain and All Mars open an embedded native ArcGIS SceneView using the public imagery/elevation services configured by Esri Explore Mars. The opening now uses the same live Esri scene as the planner. SceneView uses GCS Mars 2000 Sphere (104971), the MDEM200M elevation service and Viking MDIM global imagery, with optional HiRISE imagery. The selected mission route and Jezero POIs are overlaid; unrelated traverse/grid/coverage lines are removed from the planner. The 2D color map remains available if external services or WebGL fail.

These are regional DEMs, not near-perfect obstacle-scale topography. The MDEM service describes approximately 100 m horizontal accuracy and at least ±3 m elevation uncertainty; detail varies by source. Route planning still uses historical rover-track grades, not this rendered DEM. External ArcGIS SDK/data services require network access; their bytes are not bundled. Esri/source attribution remains visible.

If the strict heuristic cannot include the requested tasks/stops, a bounded alternative search tests larger distance/time budgets and relaxed track-grade filtering while preserving region, walking speed, blocked edges and the 20% time reserve. It can propose omitting unavailable tasks or priority stops, with every omission disclosed. The prompt reports only exceeded constraints; nothing changes until Use this route is accepted. Rejecting keeps the original settings. No candidate found is reported honestly; the heuristic is not proof of global infeasibility.

## Mission-first default view
The 3D scene now preloads during arrival and is the default planner view. The final map transition fades into that scene; 2D science layers remain explicitly labeled alternatives. Selecting a region updates the 3D camera. 3D POI popups include historical capture sol, the selected stop's science tasks and an action to open its panorama (including VR access through the panorama dialog). Only validated same-origin frame messages can request a panorama.

A compact Mission data & conditions section links the interface conceptually to the Space Apps challenge: MOLA/HRSC terrain, HiRISE/CTX/HRSC imagery, Mastcam-Z views and THEMIS historical heat context. No live weather/radiation feed is connected. Route-grade estimation remains separate from rendered DEM relief; this prototype does not claim verified astronaut safety or live conditions.

## Continuous 3D arrival and sample handoff
The CRT reveal, orbital fly-in and planner use one persistent Esri iframe. No 2D canvas snapshot is used in the arrival. The camera targets a padded extent containing all available Jezero POIs plus Martian Base, rather than setting an offset camera position and tilting north. A second non-animated extent fit after the scene docks accounts for the final viewport aspect ratio. HiRISE imagery is on by default; POIs use elevated screen-sized 3D icons so they are not buried in the terrain.

Receive Perseverance sample is a hypothetical rover-to-base handoff of Sapphire Canyon, sample 25 (Cheyava Falls). NASA's current sample catalog lists it aboard Perseverance. It is NOT a pickup from a ground cache at Cheyava Falls, NOT a claim the rover is currently at Martian Base, and NOT confirmed evidence of life. The 30-minute handling estimate is charged once, after a field route or as a base-only mission. The planner preserves its 20% reserve and includes this operation in exports. Details and primary source URLs are in dist/sample-mission.js.

Regression checks cover the one-scene arrival, terrain message protocol, default HiRISE, POI extent framing, sample-only and mixed missions, and budget alternatives. These are logic/adapter tests; physical headset and browser GPU visual verification remain outstanding.

Default soundtrack volume: 50%. Browser autoplay restrictions still apply.


## CAPCOM with live Claude (optional, server-side key)
The Anthropic API key never goes in the browser. Start the app with the included server and put the key in its environment:

    ANTHROPIC_API_KEY=sk-ant-... node scripts/serve.mjs        # or create a local .env file containing that line
    # optional: CAPCOM_MODEL=claude-sonnet-5-5  PORT via first argument  HOST=127.0.0.1

The page asks `/api/capcom`; without a key CAPCOM stays scripted. Requests are size- and rate-limited and upstream errors are not forwarded. `.env` files are excluded from the project zip.


## CAPCOM tools (live Claude)
With a server key set, CAPCOM may call: assess_route, list_alternates, preview_alternate, replan, open_panorama, set_view, abort_to_base (definitions and validation in `dist/capcom-tools.js`; the page runs them, the model only names them). Without a key CAPCOM stays scripted and never acts.


## Terrain AI
A SegFormer-B0 we fine-tuned on NASA AI4Mars labels reads the real panoramas as loose ground vs rock (trained on four classes; merged after our hand check, see the doc). It runs in the browser via onnxruntime-web: open a panorama and press "Run our model live". Results also feed Live views, route popups and CAPCOM. See `docs/TERRAIN-AI.md` for training, metrics, limits and how to re-run `scripts/run_terrain_model.py`.

## Hosting
See `docs/DEPLOY-RAILWAY.md` (Dockerfile, `railway.json`, `/healthz`, `PORT`, `TRUST_PROXY`). `npm start` runs the server.
