# AI Empire Tycoon Updates

Public update channel for AI Empire Tycoon.

## Current release

- Game: **v9.4**
- Update channel: `version.json`
- Transport: GitHub Raw (Vercel is no longer used)
- Auto-update: enabled

The permanent Windows launcher keeps the game itself at the stable local path `%LOCALAPPDATA%\AI Empire Tycoon\AI_Empire_Tycoon_v4.html` and keeps the browser profile in `%LOCALAPPDATA%\AI Empire Tycoon\Profile`, so updates do not move or reset saves.

The launcher contains v9.1 as its recovery/bundled build. Current and future gameplay releases are delivered through `version.json` as verified replacement packages or patches. Every downloaded game build is checked against its SHA-256 before it replaces the installed game.

## v9.4

v9.4 adds five major company-scale systems while keeping existing saves compatible:

- **Compute Empire:** owned datacenters now work alongside leased burst compute and switchable energy strategies with different costs, reliability and contract locks.
- **Custom AI Chips:** design and name three generations of in-house accelerators, choose a Training, Inference, Efficiency or Balanced focus, then deploy them across the fleet for real compute and power-efficiency gains.
- **Secret Research:** run classified projects such as PROJECT ORION, MIRAGE and SENTINEL. Secrecy level changes cost and leak probability, and leaks can surface as explicitly unconfirmed insider/social-media rumors.
- **Consumer AI Product:** launch a first-party assistant powered by your best language model, set Free/Plus/Pro economics, toggle ads, voice, image understanding and agent mode, and grow active users, paid conversion, retention and direct product revenue.
- **Public Stock Market:** after the IPO, shares trade every in-game day with market cap, daily movement, analyst targets, short interest, quarterly earnings reactions, buybacks and special dividends.

The Live AI Agents control is also now a persistent two-way setting. When enabled, the button changes to **Disable Live AI Agents** and the saved state shows **Enabled**. Disabling destroys the on-device session, saves the preference, and leaves the persistent simulated agent network active.

The v9.4 build is verified against SHA-256 `ba72a662a7305e8b441c29927fb006565698440eddc48422447f137941bdf66d`.

## v9.3

v9.3 expanded Social Media into a persistent agent network. Recurring agents keep opinions, memories and relationships, form reply/debate threads, react to the player's company, and include journalists, influencers and insiders. Simulation-grounded rumors/leaks are explicitly marked unconfirmed. When the browser exposes the on-device `LanguageModel` Prompt API, players can enable Live AI Agents for generated posts and replies; otherwise the persistent autonomous simulation remains active.
