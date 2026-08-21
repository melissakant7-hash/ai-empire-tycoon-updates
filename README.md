# AI Empire Tycoon Updates

Public update channel for AI Empire Tycoon.

## Current release

- Game: **v10.0.1**
- Update channel: `version.json`
- Transport: GitHub Raw (Vercel is no longer used)
- Auto-update: enabled

The permanent Windows launcher keeps the game itself at the stable local path `%LOCALAPPDATA%\AI Empire Tycoon\AI_Empire_Tycoon_v4.html` and keeps the browser profile in `%LOCALAPPDATA%\AI Empire Tycoon\Profile`, so updates do not move or reset saves.

The launcher contains v9.1 as its recovery/bundled build. Current and future gameplay releases are delivered through `version.json` as verified replacement packages or patches. Every downloaded game build is checked against its SHA-256 before it replaces the installed game.

## v10.0.1

UI and protected-distribution hotfix. The new v10 Model Training and Company HQ native select controls now use the game dark theme (including dark popup color-scheme), the Update Center release card correctly describes the installed v10 line instead of the old v9.5.0 polish pass, and Employees & Research Teams receives proper spacing and a fixed number column between the minus/plus controls.

The distributed browser build now stores the main JavaScript as a compressed protected/obfuscated payload rather than readable source text. This raises the barrier against casual source copying while preserving the existing SHA-256 verified updater. As with any offline browser-delivered game, this is not an absolute secrecy boundary because executable client code can ultimately be inspected by a determined reverse engineer.

The v10.0.1 build is verified against SHA-256 `2d3d0c25d6bd7aba96fe3cef61186e91ccdfd790e24c40d560624d6b324ab660`.

## v10.0.0

Major company-and-world gameplay expansion. The new Company HQ connects workforce allocation and morale, executive hiring, crisis management, startup acquisitions, government/regulatory posture, developer ecosystem and API reliability, press interviews, board/investor pressure, and the late-game frontier AI race. Model Lab gains real training-program decisions for compute budget, data program and safety gates; release safety policy now changes cost/risk; rival CEOs have persistent personalities and periodic strategic behavior. Startups evolve and can be acquired by the player or rivals, developer adoption responds to uptime/support, outages can escalate into crises, and frontier moonshots provide a costly endgame path to permanent capability breakthroughs.

Also included from the requested numbered ideas: AI Safety/Alignment Decisions (#7), Government & Regulation (#8), API Reliability/Outages (#14), Scandals & Crisis Management (#17), Press Conferences/Interviews (#18), Board/Investor Pressure (#19), and Endgame/AI Race (#20). Model Training Projects (#4) is integrated into Model Lab rather than duplicated.

The v10.0.0 build is verified against SHA-256 `1c725b57574a89c1fca6b475038b1d9b9ef96d81b0b8ef7568f6b3d7027e6333`.

## v9.5.0

Major non-feature polish, clarity, balance and resilience pass. Rival capability is now gated by a time-based world frontier so passive calendar progression cannot rush competitors to 99 in only a few years. Dashboard/history gain a "Why did this change?" ledger, key metrics receive explanatory tooltips, saves keep a silent last-known-good recovery copy, Local AI shows real generation diagnostics and unread company replies, empty/disabled states explain what is missing, old UI receives consistency/responsive polish, major values animate on meaningful changes, the Update Center is clearer, and long-running saves receive bounded social/history maintenance. Existing gameplay systems and saves remain compatible.

Not included by request: additional confirmation-dialog behavior, keyboard shortcuts, or new accessibility modes/options.

The v9.5.0 build is verified against SHA-256 `d78b38c33aef1fd61cf5a6fafd8769d2fa01f49952d23a7fb097d76da8d29624`.

## v9.4.11

Secret Research UX + faster Local AI hotfix. The secrecy selector already affected actual project RP/cash cost and daily leak probability, but the UI did not expose those changes, making the control look broken. v9.4.11 updates each project card immediately with the selected real cost and estimated cumulative leak risk. Local AI Social Media pacing is also reduced from 1.8 seconds to 1.2 seconds, about 50% more messages per minute, while v9.4.9 bounded-thread caps and anti-spam protections stay unchanged.

The v9.4.11 build is verified against SHA-256 `7bd4fa0e6dbc474a719798e7e1c1dc17b81cdd182e22ba9cf834adac5d94f80f`.

## v9.4.10

Local AI pacing hotfix. Local-AI Social Media generation is about 33% faster, with the minimum real-time interval reduced from 2.4 seconds to 1.8 seconds. The bounded v9.4.9 thread scheduler, active-conversation caps, fair reply draining, AI-only behavior and anti-spam protections are unchanged.

The v9.4.10 build is verified against SHA-256 `e4c59333b7af77ffb1f4d9c6e5c13a0aa5b887220db90cc5b29911d1294bcf0b`.

## v9.4.9

Bounded Local-AI thread scheduler hotfix. v9.4.8 could create 2–4 queued replies for every new autonomous root post while only consuming roughly one reply every other Social Media slot, so the queue could grow indefinitely. v9.4.9 only turns discussion-worthy autonomous posts into debates, caps the active conversation pool, trims legacy v9.4.8 backlog on migration, and gives replies more scheduler slots whenever several conversations are active. Player-company posts and announcements remain prioritized for real replies.

The v9.4.9 build is verified against SHA-256 `9ea7e933e7b3e4127895533e35e1ddc764f99b5ffb0e6143cadcf1535712f77a`.

## v9.4.8

Social Media pacing and multi-thread reliability hotfix. The Local AI scheduler now targets roughly one new agent post or reply every 2.4 seconds of real time, including at high Sandbox speed, while rotating fairly between the player company conversation, other reply chains and new root posts. Company announcements receive their first replies with priority, then stop monopolizing the queue so several conversations can develop in parallel.

Hot Debate now shows up to six active or developing threads at the same time instead of waiting for only fully-developed reply chains. Local-AI thread jobs are round-robin/fairly scheduled, failed anti-repetition drafts no longer block the whole network, and Local AI root generation retries from different perspectives before re-queuing a topic. When Local AI is enabled, hard guards block legacy simulation post/reply/rumor paths; if the local model is unavailable the network waits rather than creating fallback simulation text.

The v9.4.8 build is verified against SHA-256 `f5e06e0e483c98e491595869604b929c741307010fd3426dd7d78f06477a3135`.

## v9.4.7

Local-AI thread reliability hotfix. Reputation-based company posts now put their expected replies into a persistent save-backed queue instead of attempting a fragile immediate burst. Each queued reply consumes a normal paced social publishing slot, so a target conversation such as 7 replies visibly progresses 0/7 → 1/7 → … → 7/7. Existing v9.4.6 player posts with an unfulfilled reply target are migrated into this queue automatically. Autonomous Local-AI threads also grow through the same paced queue so Hot Debate remains active without instant reply spam.

The Local AI Enabled choice is now sticky across browser/model initialization problems. If the local LanguageModel is unavailable or still preparing, Social Media enters **AI-ONLY WAITING** and creates no simulated fallback text; queued work resumes automatically when the model becomes ready. Every agent message now exposes its actual provenance with a **LOCAL AI** or **SIMULATION** badge, including historical posts already present in saves. News seeding and secret-project leaks also respect AI-only mode.

The v9.4.7 build is verified against SHA-256 `40c371352964e80f70a8f1a94e92bfd9cd5e9dfd41499f8fd0ed757125a6a42b`.

## v9.4.6

Reputation-powered social reach and strict Local-AI-only generation. Posts from the player company account now derive reach, initial likes, repost velocity and real reply depth from company reputation, brand and audience size. At high reputation, new company posts are deliberately positioned above ordinary recent network posts in engagement, while lower-reputation companies receive more modest reach. Reply totals are backed by actual thread messages rather than cosmetic counters.

When Live AI Agents are enabled and the browser-managed local LanguageModel session is ready, every **new agent-written** root post, reply and Hot Debate message is generated by that local model. Model-release reactions, company events, pricing/usage reactions and rumors are queued into the same paced social scheduler instead of producing template fallback text. The existing real-time and in-game pacing limits remain in force, and enabling Local AI no longer creates an immediate burst of posts. If Local AI is enabled but its session is still preparing, agent generation waits rather than silently falling back to templates. Existing historical posts in saves are preserved.

The v9.4.6 build is verified against SHA-256 `de832eab0e401e5570832b2a7fd8e2b4954f409938271027b4c4ba2961301809`.

## v9.4.5

Social consequences and usage-economics update. Posts written from the player company account are now interpreted by their content and can move reputation, brand strength, active users, consumer demand and — after an IPO — investor/share-price sentiment. Product and research announcements, transparency/safety communication, customer-friendly pricing or usage changes, margin-first cuts, layoffs, apologies, overhype and hostile communication produce different consequences. Official announcements have stronger effects, while replies have smaller effects. Each player-authored post displays its resulting company impact in the social timeline.

Language-model subscription usage limits now have a direct serving-cost trade-off. Higher allowances increase inference/accelerator cost and lower allowances reduce it. Efficiency research, newer hardware and custom silicon reduce marginal serving cost. Finance now includes an **Inference & Usage** operating-cost line, and each released language model shows its estimated serving cost per day beside ARPU, paid mix and average usage load.

The v9.4.5 build is verified against SHA-256 `026b7a9162e86b12f74d82979fac90f733a9f681bcd76e5bba4c2f08b4192ac8`.

## v9.4.4

Social Media remake and pacing hotfix. The timeline now behaves more like an interactive X/Twitter feed: the player can post from the company account or publish marked official announcements, like and repost posts, open full reply threads and reply as the company. Latest Posts shows root posts rather than flattening every reply into the main feed. Hot Debate keeps up to four active conversations visible at once instead of replacing the only visible debate whenever the simulation refreshes.

Autonomous posting is rate-limited in both real time and simulation time so 5× Sandbox speed no longer floods the feed. When Live AI Agents are enabled and an on-device LanguageModel session is actually available, Live AI is preferred for new autonomous root posts rather than being added on top of a template post. Both Live AI and simulation fallback use stronger anti-repetition checks; the fallback now varies perspective by persona and role. Subscription price and usage-limit changes can enter the social discussion with concrete judgments about whether a tier is restrictive, generous or worth its price.

The v9.4.4 build is verified against SHA-256 `70a3376f101e211dc65b05db0115497de7ff94e8ae1d551cff75dc04797423c7`.

## v9.4.3

Small Model Labs subscription-management update. The paid-tier badges again show their real usage relationship — **Plus: 5× higher than Free**, **Pro x5: 5× higher than Plus**, and **Pro x20: 20× higher than Plus** by default — instead of the generic “subscription” label. Each released language model now also has a second slider per paid tier for managing that model’s usage allowance. Usage choices are saved per model and feed into paid-tier demand and average usage load.

The v9.4.3 build is verified against SHA-256 `728ac8d99ae1ebacf14cd245aba63e510c909f7dde83b8c170c3b1bd00602109`.

## v9.4.2

Small Sandbox quality-of-life update: the Sandbox Control Center now includes a persistent simulation-speed slider from **1× to 5×** in 0.25× steps. Changing it while the game is running immediately changes the tick rate; changing it while paused sets the speed used by Continue. The value is saved with the Sandbox company and Career speed behavior is unchanged.

The v9.4.2 build is verified against SHA-256 `904e46f54f63843986c6a0b7289f0e37b206184e21a5402a2dee6aba1f54ce66`.

## v9.4.1

Hotfix for interaction controls that were being replaced by the simulation render loop while open. Native dropdowns and active inputs are now protected during interaction, deferred renders resume immediately after focus leaves the control, and the Custom AI Silicon focus plus Secret Research secrecy choices persist across refreshes. Existing v9.4 saves and gameplay systems remain compatible.

The v9.4.1 build is verified against SHA-256 `3fe1184281b7c3abfb96057d6af98304e144f87fd2f6233dcd46934362178a96`.

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
