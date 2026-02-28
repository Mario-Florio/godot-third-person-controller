# Appendix

## 1. Terms

| Term | Definition |
|---   |---
| **Abstract actor** | Any agent whose intent is interpreted and acted upon by the controller; commonly referred to as "character", "player", "entity", etc.
| **Authoritative state** | State whose meaning, validity, and mutation rules are owned by the system
| **Controller (software principle)** | A distinct component which is responsible for coordination, delegation, and overall orchestration of other components within a system; not to be confused with the game-development [*controller*](/docs/design_doc/architecture.md#2-what-is-a-controller)
| **Domain** | A cohesive runtime unit that owns a responsibility (or facet of it), its state, and its authority boundaries
| **Domain-controller** | An orchestrator of a particular responsibility (or facet of it); delegates submodules to handle low-level implementation
| **Intent** | Primitive / unrefined representation of what the actor wants to do, independent of physical realization
| **Materialized state** | The concrete manifestation of state in engine objects
| **Motion intent** | A refined intent aimed specifically at producing motion
| **Motion proposal / proposal** | Structured, concrete deltas or signals that can be used to execute motion; consumed by Motion Authority
| **Realization intent** | A refined intent prepared to produce physical action
| **Realization proposal** | Structured, concrete deltas or signals that can be executed/applied; consumed by Realization Authority domains
| **Reference-basis / POV** | Concrete delta or signal that can be executed/applied; produced later by Motion Authority
| **Root-controller** | An orchestrator of responsibilites (via domain-controllers); contrasts domain-controller
| **Semantic action** | A resolved, meaningful motion intent derived from intent (e.g., “walk forward at speed X” or “face target Y”); still abstract, not applied to the abstract actor yet
| **View-apparatus** | The system or mechanism that mediates the spatial frame of reference through which input is interpreted and intent is visualized; commonly a camera

**Links**

* [README](../../README.md)
* [Design Doc — Introduction](./introduction.md)
* [Design Doc — Architecture](./architecture.md)
* [Design Doc — System Design](./system_design.md)
* [Design Doc — Appendix (currently here)](./appendix.md)