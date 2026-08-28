# AI Training Licensing & Release Endpoint

Current Full Game version: **v10.7.12**.

## v10.7.12

- Introduces one **shared physical datacenter fleet**. Language/API serving, active Language/Graphics model training, cloud gaming, AI cloud rendering, platform/update overhead and hardware-development simulation now compete for the same physical capacity.
- Active training is a hard fleet reservation. Starting a large training run can push customer workloads into reduced service until more datacenter capacity is built, leased or made more efficient.
- The shared capacity panel breaks usage down in PF for Language/API traffic, active training, cloud gaming, cloud rendering and platform/R&D overhead, while keeping the physical utilization ceiling at 100%.
- Local Graphics AI products remain realistic: Super Resolution, Frame Generation and Ray Reconstruction run on the customer's GPU after distribution and do **not** consume the company's datacenter serving capacity during local gameplay.
- Adds **AI Cloud Gaming** as a server-side subscription product. Potential subscribers, served subscribers, waitlisted users, fleet demand, pricing and daily revenue are simulated.
- Adds **AI Render Cloud** for studio/creator rendering, neural reconstruction and denoising jobs. Excess work forms a visible render queue when fleet capacity is unavailable.
- Adds two independent Graphics research lanes: **Cloud Graphics & Streaming** and **AI Gaming Silicon**. They do not require Language/Core research.
- Cloud Graphics research unlocks AI Render Cloud, neural render scheduling, AI Cloud Gaming, predictive streaming and unified cloud-graphics orchestration.
- AI Gaming Silicon research unlocks a **Neural Gaming CPU**, **Neural Gaming GPU**, local neural gaming runtime, **Unified AI Gaming Processor**, and later datacenter-optimized gaming silicon.
- Gaming CPU/GPU products are local consumer hardware with dedicated neural acceleration. Their normal customer usage does not consume company datacenter capacity, while their development simulation/verification temporarily reserves shared fleet capacity.
- Difficulty now affects the new infrastructure economy as well as the existing systems: Relaxed has more effective fleet headroom and cheaper/faster hardware projects; Hard and Brutal have less effective fleet capacity, heavier usage pressure, and more expensive/slower cloud/hardware projects.
- Keeps v10.7.11's longer model-adoption curves and waitlisted customer demand, v10.7.10's hard 100% physical ceiling and interaction-stability fix, the Sandbox serving controls, independent Graphics research, replacement-license fix, hardware-bound AITL2 licensing, signed live validation, human-voice tutorial narration and shared browser profile.

This public repository provides AI Training release metadata and live license revocation data. The paid Full Game package is **not distributed from this public repository**.

Public files contain no private signing seed, no content master key, and no playable Full Game package.
