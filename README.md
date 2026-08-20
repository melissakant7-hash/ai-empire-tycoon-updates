# AI Empire Tycoon Updates

Public update channel for AI Empire Tycoon.

## Current release

- Game: **v9.3**
- Update channel: `version.json`
- Transport: GitHub Raw (Vercel is no longer used)
- Auto-update: enabled

The permanent Windows launcher keeps the game itself at the stable local path `%LOCALAPPDATA%\AI Empire Tycoon\AI_Empire_Tycoon_v4.html` and keeps the browser profile in `%LOCALAPPDATA%\AI Empire Tycoon\Profile`, so updates do not move or reset saves.

The launcher contains v9.1 as its recovery/bundled build. Current and future gameplay releases are delivered through `version.json` as verified replacement packages or patches. Every downloaded game build is checked against its SHA-256 before it replaces the installed game.

## v9.3

v9.3 expands Social Media into a persistent agent network. Recurring agents keep opinions, memories and relationships, form reply/debate threads, react to the player's company, and include journalists, influencers and insiders. Simulation-grounded rumors/leaks are explicitly marked unconfirmed. When the browser exposes the on-device `LanguageModel` Prompt API, players can enable Live AI Agents for generated posts and replies; otherwise the persistent autonomous simulation remains active.

The v9.3 update is published as gzip/base64 package parts referenced by `version.json` and is verified against SHA-256 `6a8c6a60207ef85b88469aa591e3d7597da55dcda1fea3e2b57ee56bcda7acee`.
