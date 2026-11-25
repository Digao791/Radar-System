# Sentinel Radar frontend

Replace the existing frontend directory with this directory. Run `npm install`, then `npm run build` and `npm run dev`. Start Ada on port 8080. Commit the generated package-lock.json before using Docker (npm ci). Existing Nginx must proxy /api/ to api:8080 without stripping the prefix and use try_files for SPA routes.

No Next.js or simulation backend. Display preferences are in memory; range is read-only. No lost contacts or observation history are invented. Heading is converted from Ada's mathematical angle (east, counterclockwise) to compass bearing (north, clockwise). Distances and speeds use simulation units.

Build not executed: npm registry unavailable in generation environment.
