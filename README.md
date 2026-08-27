# AI Training Licensing & Release Endpoint

Current Full Game version: **v10.7.10**.

## v10.7.10

- Makes datacenter serving a physical **100% maximum**. The utilization meter and history graph never exceed 100%.
- When requested Language AI traffic is above fleet capacity, the excess becomes **unserved demand** and **paused customers** instead of impossible 100%+ utilization.
- Subscription/API revenue is reduced to the percentage of traffic the fleet can actually serve; paused demand does not generate normal revenue, and serving cost follows the actually served workload.
- The Datacenters capacity panel now shows demand, fleet capacity, utilization, traffic served, unserved demand and paused customers separately.
- Increasing subscription settings that would exceed available serving capacity remains blocked until capacity is expanded or demand is reduced.
- Fixes the Model Type selector getting stuck on **Cybersecurity AI** after it had been selected. Language AI, Graphics AI and Cybersecurity AI can now be switched normally.
- Adds a global interaction-stability guard for buttons, sliders, selects and other controls. Automatic simulation renders are deferred while a control is being hovered/pressed, preventing UI replacement between pointer-down and pointer-up, hover flicker and missed clicks across Subscription configuration, Datacenters and the rest of the game.
- Keeps the v10.7.9 Sandbox serving fix: infinite Sandbox training compute stays separate from the real physical serving fleet when Unlimited Datacenter Serving Capacity is OFF.
- Keeps the v10.7.7/v10.7.8 serving economy, model optimization generations, stronger Custom AI Silicon, visible rival cyber damage and rebalanced difficulties.
- Keeps independent Graphics research, Unlock All Research, replacement-license fix, hardware-bound AITL2 licensing, live validation, human-voice tutorial narration, shared browser profile and no-blur tutorial.

This public repository provides AI Training release metadata and live license revocation data. The paid Full Game package is **not distributed from this public repository**.

Public files contain no private signing seed, no content master key, and no playable Full Game package.
