# AI Training Licensing & Release Endpoint

Current Full Game version: **v10.10.13**.

## v10.10.13

- Moves **Update Center** out of Finance and into **Settings**, where version/update controls belong.
- Fixes Update Center and Game Health locale handling so English sessions use English labels and German sessions use German labels.
- Removes the stale **v10.0.2** release/version text and replaces visible release information with the current build.
- Keeps the v10.10.11 Model Lab interaction fix and v10.10.12 immediate completed-model refresh and smooth scrolling fixes.
- Enables the GitHub release manifest (`autoUpdate: true`). The v10.10.13 Windows bootstrap checks `version.json` before launch, verifies downloaded update packages by SHA-256, and falls back to the last known-good local package if the network or update download fails.
- The updater download path is implemented, but this public repository remains metadata-only and does not publish the paid Full Game binary. A future newer manifest must provide an authorized `downloadUrl`, `gameUrl`, `launcherUrl`, or package parts plus the matching SHA-256 before that newer package can be downloaded automatically.

This public repository provides AI Training release metadata and live license revocation data. The paid Full Game package is **not distributed from this public repository**.

Public files contain no private signing seed, no content master key, and no playable Full Game package.
