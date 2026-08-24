# AI Training Licensing & Release Endpoint

Current Full Game version: **v10.7.3**.

## v10.7.3

- Restores the Generation 2 hardware-bound **AITL2** license gate before paid Full Game content is served.
- Existing AITL2 licenses remain compatible on the same Windows device identity.
- Activation and license state are stored with Windows Protected Data (DPAPI).
- The signed publisher revocation list is checked at startup and repeatedly while the game is running; a revoked license loses gameplay access.
- Offline play remains available for up to 24 hours after the last successful online license validation.
- Adds optional tutorial voice narration. German UI uses a German voice and English UI uses an English voice when a compatible Chromium/Windows speech voice is available.
- Keeps the v10.7.2 sharp no-blur tutorial, one-time automatic tutorial start, complete German tutorial and broader German localization.

This public repository provides AI Training release metadata and live license revocation data. The paid Full Game package is **not distributed from this public repository**.

Public files contain no private signing seed, no content master key, and no playable Full Game package.
