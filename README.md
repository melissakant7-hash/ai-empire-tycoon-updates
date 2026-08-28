# AI Training Licensing & Release Endpoint

Current Full Game version: **v10.7.13**.

## v10.7.13

- Fixes the Datacenters tab briefly flashing the obsolete **Serving Capacity** UI before the newer **Shared Physical Compute** panel appears.
- The older v10.7.7/v10.7.10 capacity renderer remains available internally for compatibility with existing serving-economy code, but its legacy `.v1077Cap` panel is now hidden in the document head before any render can paint it.
- Switching away from Datacenters and returning now keeps the new shared-compute presentation stable instead of showing the old graph/UI for a frame.
- Keeps all v10.7.12 systems: one shared physical datacenter fleet for Language/API serving, model training, cloud gaming, AI cloud rendering, platform/R&D overhead and hardware-development simulation.
- Keeps local Super Resolution, Frame Generation and Ray Reconstruction as customer-device workloads that do not consume company datacenter capacity during gameplay.
- Keeps AI Cloud Gaming, AI Render Cloud, the independent Cloud Graphics & Streaming and AI Gaming Silicon research lanes, Neural Gaming CPU/GPU and Unified AI Gaming Processor systems.
- Keeps the expanded difficulty modifiers for fleet efficiency, compute pressure and hardware/cloud project cost/time.
- Keeps v10.7.11 model-adoption/waitlist behavior, v10.7.10 hard 100% capacity ceiling and global interaction-stability fix, Sandbox serving controls, replacement-license fix, hardware-bound AITL2 licensing, signed live validation, human-voice tutorial narration and shared browser profile.

This public repository provides AI Training release metadata and live license revocation data. The paid Full Game package is **not distributed from this public repository**.

Public files contain no private signing seed, no content master key, and no playable Full Game package.
