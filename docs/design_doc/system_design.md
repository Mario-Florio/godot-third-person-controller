# Godot Third-Person Controller (v1) — System Design

**Index**

- [Godot Third-Person Controller (v1) — System Design](#godot-third-person-controller-v1--system-design)
  - [1. System Overview \& Execution Model](#1-system-overview--execution-model)
    - [1.1 System Participants](#11-system-participants)
      - [1.1.1 Intent-Realization Pipeline](#111-intent-realization-pipeline)
      - [1.1.2 Responsibilities](#112-responsibilities)
      - [1.1.3 Domain-controllers](#113-domain-controllers)
      - [1.1.4 Snapshots](#114-snapshots)
      - [1.1.5 Pipeline Artifacts](#115-pipeline-artifacts)
      - [1.1.6 Adapters](#116-adapters)
    - [1.2 Execution Model](#12-execution-model)
      - [1.2.1 Update Cadence](#121-update-cadence)
      - [1.2.2 Pipeline Ordering](#122-pipeline-ordering)
      - [1.2.3 Temporal \& Determinism Guarantees](#123-temporal--determinism-guarantees)
    - [1.3 Control Flow](#13-control-flow)
    - [1.4 Boundary Enforcement](#14-boundary-enforcement)
      - [1.4.1 Communication Contracts](#141-communication-contracts)
      - [1.4.2 Prohibitions](#142-prohibitions)
      - [1.4.3 Enforcement Mechanisms](#143-enforcement-mechanisms)
      - [1.4.4 Design Rationale](#144-design-rationale)
  - [2. Concrete Responsibility Realizations](#2-concrete-responsibility-realizations)
    - [2.1 Input Interface](#21-input-interface)
      - [2.1.1 Purpose \& Architecural Role](#211-purpose--architecural-role)
      - [2.1.2 Owned State \& Mutation Authority](#212-owned-state--mutation-authority)
      - [2.1.3 Inputs, Dependencies, and Assumptions](#213-inputs-dependencies-and-assumptions)
      - [2.1.4 Outputs \& Downstream Effects](#214-outputs--downstream-effects)
      - [2.1.5 Behavioral Variants \& Resolution Strategies](#215-behavioral-variants--resolution-strategies)
      - [2.1.6 Temporal Characteristics](#216-temporal-characteristics)
      - [2.1.7 Extension \& Substitution Surfaces](#217-extension--substitution-surfaces)
      - [2.1.8 Non-Goals \& Explicit Exclusions](#218-non-goals--explicit-exclusions)
    - [2.2 View-Intent Mediation](#22-view-intent-mediation)
      - [2.2.1 Purpose \& Architecural Role](#221-purpose--architecural-role)
      - [2.2.2 Owned State \& Mutation Authority](#222-owned-state--mutation-authority)
      - [2.2.3 Inputs, Dependencies, and Assumptions](#223-inputs-dependencies-and-assumptions)
      - [2.2.4 Outputs \& Downstream Effects](#224-outputs--downstream-effects)
      - [2.2.5 Behavioral Variants \& Resolution Strategies](#225-behavioral-variants--resolution-strategies)
      - [2.2.6 Temporal Characteristics](#226-temporal-characteristics)
      - [2.2.7 Extension \& Substitution Surfaces](#227-extension--substitution-surfaces)
      - [2.2.8 Non-Goals \& Explicit Exclusions](#228-non-goals--explicit-exclusions)
    - [2.3 Intent Resolution](#23-intent-resolution)
      - [2.3.1 Purpose \& Architecural Role](#231-purpose--architecural-role)
      - [2.3.2 Owned State \& Mutation Authority](#232-owned-state--mutation-authority)
      - [2.3.3 Inputs, Dependencies, and Assumptions](#233-inputs-dependencies-and-assumptions)
      - [2.3.4 Outputs \& Downstream Effects](#234-outputs--downstream-effects)
      - [2.3.5 Behavioral Variants \& Resolution Strategies](#235-behavioral-variants--resolution-strategies)
      - [2.3.6 Temporal Characteristics](#236-temporal-characteristics)
      - [2.3.7 Extension \& Substitution Surfaces](#237-extension--substitution-surfaces)
      - [2.3.8 Non-Goals \& Explicit Exclusions](#238-non-goals--explicit-exclusions)
    - [2.4 Realization Authority](#24-realization-authority)
      - [2.4.1 Purpose \& Architecural Role](#241-purpose--architecural-role)
      - [2.4.2 Owned State \& Mutation Authority](#242-owned-state--mutation-authority)
      - [2.4.3 Inputs, Dependencies, and Assumptions](#243-inputs-dependencies-and-assumptions)
      - [2.4.4 Outputs \& Downstream Effects](#244-outputs--downstream-effects)
      - [2.4.5 Behavioral Variants \& Resolution Strategies](#245-behavioral-variants--resolution-strategies)
      - [2.4.6 Temporal Characteristics](#246-temporal-characteristics)
      - [2.4.7 Extension \& Substitution Surfaces](#247-extension--substitution-surfaces)
      - [2.4.8 Non-Goals \& Explicit Exclusions](#248-non-goals--explicit-exclusions)
    - [2.5 Presentation Model](#25-presentation-model)
  - [3. Data Structures \& Contracts](#3-data-structures--contracts)
    - [3.1 Design Goals \& Constraints](#31-design-goals--constraints)
    - [3.2 Core Data Structures](#32-core-data-structures)
      - [3.2.1 Intent-Bearing Input](#321-intent-bearing-input)
      - [3.2.2 Reference-Basis](#322-reference-basis)
      - [3.2.3 Motion Intent](#323-motion-intent)
      - [3.2.4 Motion Proposal](#324-motion-proposal)
      - [3.2.5 Physical Actor State](#325-physical-actor-state)
      - [3.2.6 Snapshot](#326-snapshot)
    - [3.3 Contractual Guarantees](#33-contractual-guarantees)
    - [3.4 Language \& Engine Bindings](#34-language--engine-bindings)
    - [3.5 Non-Goals \& Deferred Decisions](#35-non-goals--deferred-decisions)
  - [4. Composition \& Wiring Strategy](#4-composition--wiring-strategy)
  - [5. Variability, Substitution, and Extension Points](#5-variability-substitution-and-extension-points)
  - [6. Configuration \& Authoring Model](#6-configuration--authoring-model)
  - [Links](#links)

**Links**

* [README](../../README.md)
* [Design Doc — Introduction](./introduction.md)
* [Design Doc — Architecture](./architecture.md)
* [Design Doc — System Design (currently here)](./system_design.md)
* [Design Doc — Appendix](./appendix.md)

---

## 1. System Overview & Execution Model

### 1.1 System Participants

#### 1.1.1 Intent-Realization Pipeline
* Orchestrates execution order
* Enforces architectural contracts
  * Execution order
  * Authority boundaries
* Coordinates communication across domain boundaries

#### 1.1.2 Responsibilities
* Orchestrates implementation of domains
* Implements boundary enforcement protocols & communication contracts:
  * Intent-bearing input
  * Reference-basis
  * Semantic intent
  * Physical actor state
  * Adapters

#### 1.1.3 Domain-controllers
* Implements specific duties of resposibilities
* Owns domain-specific state and implementation
* Delegates low-level tasks

#### 1.1.4 Snapshots
* Ephemeral, transient captures of a domain's state
* Contract for general, cross-domain communication
* Read-only

#### 1.1.5 Pipeline Artifacts
* Fulfill need for structured, non-primitive data transfer across domains
* Exist to help maintain boundaries across domains:
  * Motion Intent
    * Communication contract for domains desiring to produce realized motion
    * Can infer proposal without knowing Motion Proposals implementation
  * Motion Proposal — first-class Motion Authority struct

#### 1.1.6 Adapters
* Serve wiring of system domains
  * Payloads
    * A domain controlled interface that dependencies can be injected
  * Motion Proposal Factory
    * Creates Motion Proposals from Motion Intents
  * Speed Tier Converters
    * Converts between Speed Intent & Speed Tier to aid communication without relying on structural dependency 

### 1.2 Execution Model

#### 1.2.1 Update Cadence
* The system operates on a frame-coordinated evaluation model
  * All responsibilities are evaluated once per tick
  * Continuous signals and time-dependent state are sampled and processed during this evaluation
* Event-driven mutation is permitted for discrete, semantic state transitions
  * Events mutate configuration-level or modal state, not continuous signals
  * Event-driven mutation does not replace per-frame evaluation
  * Events should never mutate state which frame-coordinated evaluation directly depends on for derivation
  * Events mutate polling conditions (e.g. `event_ocurred`); frame-coordinated evaluation makes any updates to state
* As a rule:
  * Continuous, time-extended state is frame-evaluated
  * Discrete, semantic transitions are event-mutated
* This hybrid model:
  * Preserves deterministic execution and debuggability
  * Reduces per-frame conditional noise
  * Improves semantic clarity by making infrequent transitions explicit

#### 1.2.2 Pipeline Ordering
1. Upstream responsibilities execute
2. Authoritative state is sampled
3. Derived artifacts are produced
4. Proposals are realized

#### 1.2.3 Temporal & Determinism Guarantees
* Authoritative state is mutated once, during owners execution
* Consumption/production cycles happen once per frame
* Motion proposals are resolved after all motion intents are derived

### 1.3 Control Flow
1. Input Interface consumes control-relevant signals -> produces intent-bearing input -> intent-snapshot created
2. View-Intent Mediation consumes intent-snapshot -> mutates reference-basis and view-apparatus state
3. Intent Resolution consumes intent-snapshot -> produces motion intent
4. Intermediary consumes motion intent -> produces motion proposal
5. Motion Authority consumes motion proposal -> mutates Physical Actor State -> motion-snapshot created
6. Presentation Mediation consumes motion-snapshot -> updates visuals

(Note: this section should demonstrate who triggers what, and how data-shape & state change across an execution cycle)

### 1.4 Boundary Enforcement

#### 1.4.1 Communication Contracts
* Communication across domains is orchestrated by the root-controller
* Shared state is handled through read-only snapshots
* In cases where data communication requires high-level structure, intermediaries are used:
  * Motion Intent -> Motion Proposal Factory -> Motion Proposal
  * This reduces structural coupling and maintains composibility of responsibilites

#### 1.4.2 Prohibitions
* Domains do not directly access, nor directly communicate with peers
* All domain-scoped state is shared strictly through snapshots

#### 1.4.3 Enforcement Mechanisms
* Snapshots:
  * Read-only access
* Motion Proposal Factory serves as an adapter between Motion Intent producers and Motion Proposals (a first-class Motion Authority consumable)

#### 1.4.4 Design Rationale
* Boundaries exist to:
  * Maintain composability
  * Simplify debugging

## 2. Concrete Responsibility Realizations

### 2.1 Input Interface

#### 2.1.1 Purpose & Architecural Role
* The ingress boundary where exogenous signals become first-class causal inputs to the controller pipeline
* Input surface for externally authored intents to be admitted into the system
* It provides intent-bearing input ready for downstream consumption
* Owns system admission and struturing
* It does not own meaning

#### 2.1.2 Owned State & Mutation Authority
* Owns transient intent signals
* Mutation is allowed:
  * Per-frame on continuous signals
  * On-demand for discrete signals
* Does not own semantic structuring of intent

#### 2.1.3 Inputs, Dependencies, and Assumptions
* Consumes raw, external authored inputs, outside the auhtority of the controller (the following is non-exhaustive):
  * User/player input
  * AI directives
  * Feedback from prior execution cycles (e.g., root-motion)
  * Environmental events or singals (e.g., cinematics, world state, etc.)

#### 2.1.4 Outputs & Downstream Effects
* Intent-bearing input
  * Formatted in a way which is consumable downstream with minimal assumptions made
  * Expresses intent, not meaning
* Authoritative producer of raw intent
  * Downstream consumers may derive meaning, not mutate source or infer intent beyond given signal

#### 2.1.5 Behavioral Variants & Resolution Strategies
* This responsibility can be realized through the following strategies:
  * Modular handling across domains (I.e., multiple, specialized domain-controllers):
    * User input
    * Environmental input
    * AI input
  * Monolith handling
* Modular handling is preferred because it
  * Allows for greater composability
  * Increases readability
  * Maintains SoC at the domain level

#### 2.1.6 Temporal Characteristics
* Provides continuous input signal per frame
  * Polling happens exactly once, at the beginning of the frame
* Provides discrete input signal on-demand

#### 2.1.7 Extension & Substitution Surfaces
* Extensions can be made via
  * Additional input sources
  * Alternative aggregation strategies
* Extensions must adhere to invariants:
  * Output contract (intent-bearing input)
  * Preserved boundaries (e.g., no semantic inference)

#### 2.1.8 Non-Goals & Explicit Exclusions
* Interpret intent
* Resolve conflicts in input
* Apply motion
* Manage downstream orchestration

### 2.2 View-Intent Mediation

#### 2.2.1 Purpose & Architecural Role
* Provide a view-based reference-basis from which intent is expressed from
* Manage reference-basis' and view-apparatus'
* Defines how intent-bearing input is routed to exactly one view-apparatus per frame
* Acts as the bridge between abstract input intent and concrete spatial reference
* Enforces the invariant: at most one view-apparatus consumes view-intent per update

#### 2.2.2 Owned State & Mutation Authority
* Owns:
  * Canonical reference-basis
  * Active view-apparatus
  * Reference-basis / view-apparatus storage
  * Optional:
    * Lifecycle state for activation/deactivation (enter/exit hooks)
    * Transient mediation metadata (e.g., handoff reason, priority source)
* Can mutate:
  * Canonical reference-basis
  * Active view-apparatus — other systems can request change, not enact them

#### 2.2.3 Inputs, Dependencies, and Assumptions
* Consumes intent-bearing input:
  * View direction
  * Reference-basis / view-apparatus requests
* Depends on abstract view-apparatus interface
* Assumes view-apparatus provides interface (communication contract)

#### 2.2.4 Outputs & Downstream Effects
* Canonical reference-basis derived from active view-apparatus
* Downstream systems (e.g. Intent Resolution) consume this reference

#### 2.2.5 Behavioral Variants & Resolution Strategies
* Primary-follow view-apparatus
* Contextual overrides (fixed / cinematic)
* Priority-based arbitration

#### 2.2.6 Temporal Characteristics
* Evaluates once per update cycle
  * Active view-apparatus state change (not active view-apparatus swapping)
  * Priority resolution
* On-demand signals include
  * View-apparatus registration
  * Externally authoritative overrides

#### 2.2.7 Extension & Substitution Surfaces
* New view-apparatus types
* Alternative mediation policies
* Arbitration logic
* Key constraints:
  * Extensions must preserve the single-consumer invariant
  * Consumers must implement consumer-contract

#### 2.2.8 Non-Goals & Explicit Exclusions
* Does not interpret locomotion intent
* Does not coordinate rendering or visual effects
* Does not decide why a camera becomes active—only which is active

### 2.3 Intent Resolution

#### 2.3.1 Purpose & Architecural Role
* Derive motion intent from reference-basis & intent-bearing input
* Intrepet intent into coherent, meaningful abstract actor action
  * Intent becomes actor-centric and semantically complete

#### 2.3.2 Owned State & Mutation Authority
* Owns:
  * Semantic states (e.g., bounded, double-jump, etc.)
  * Speed-tiers (e.g., walking vs jogging vs running)
* Derives:
  * Boundedness (e.g., "Is reference-basis local or canonically bound?") from select sources (likely physical actor state from prior cycle)

#### 2.3.3 Inputs, Dependencies, and Assumptions
* Intent-bearing input
* Canonical reference-basis
* Physical actor state

#### 2.3.4 Outputs & Downstream Effects
* Outputs semantic intent
* Fuels realization proposal processing (e.g., motion intent -> motion proposal <- Motion Authority)
* Creates the content to be resolved into motion (by Motion Authority)

#### 2.3.5 Behavioral Variants & Resolution Strategies
* Behavioral variants:
  * Semantic authoring
  * Implicit motion deltas
* Resolution Strategies:
  * Locomotion Semantics
    * Authors semantic actions from intent-bearing input
    * Must explicitly author semantics and manage the state required to derive meaning from intent-bearing input
  * Feedback driven (e.g., root-motion delta from prior cycle)
    * Root-motion — doesn't require explicit authoring; uses implicit deltas

#### 2.3.6 Temporal Characteristics
* Evaluates once per cycle
  * Determines boundedness
  * Authors a coherent set of semantic intents
* On-demand:
  * Speed-tier changes related to environmental triggers (e.g., walk as default if safe; run as default if in danger)

#### 2.3.7 Extension & Substitution Surfaces
* Authoring logic of motion intent
  * Semantic action sets (I.e., locomotion styles)
    * Forward-facing direction
    * Directional movement
    * Complex actions (e.g., jump, dash, thrust, etc.)

#### 2.3.8 Non-Goals & Explicit Exclusions
* Does not
  * Execute physical actions
  * Concern itself with raw physical actor state (outside of observation)
  * Validate physical feasibility
* Intent Resolution is agnostic to view-apparatus selection

### 2.4 Realization Authority

#### 2.4.1 Purpose & Architecural Role
* Appraise all realization proposals based on rules / constraints & priority arbitration
* Resolve all proposals into executable physical actor action
* Enforce physics invariants on physical actor state
* Execute physical motion

#### 2.4.2 Owned State & Mutation Authority
* Owns (authoritative):
  * Physical actor state
    * Spatial position and orientation (as resolved by physics)
    * Velocity and motion classification (e.g., grounded, airborne)
    * Constraint satisfaction and invariant enforcement

* Maintains (derived, non-authoritative):
  * Cached observations of materialized state, e.g.:
    * Last yaw
    * Last floor contact
    * Last resolved velocity

#### 2.4.3 Inputs, Dependencies, and Assumptions
* Realization proposals (first-class)
* Abstract actor targets
  * Execution substrates through which physical actor state is realized
  * Assumed to be exclusively mutable by Realization Authority
  * Treated as imperative interfaces, not stateful data

#### 2.4.4 Outputs & Downstream Effects
* Produces authoritative physical actor state
  * Spatial position and orientation
  * Velocity and motion classification
* Materializes resolved state through abstract actor targets
  * Executes motion via engine-level substrates
* Emits observable state for downstream consumers
  * Presentation mediation (animation, visuals)
* Serves as the terminal consumer of motion proposals
  * No downstream system may reinterpret or re-author motion intent

#### 2.4.5 Behavioral Variants & Resolution Strategies
* Proposal resolution strategies may vary by implementation:
  * Single-proposal execution (default)
  * Priority-based arbitration
  * Constraint-filtered selection
* Constraint enforcement strategies:
  * Hard rejection (proposal discarded)
  * Clamping / projection (proposal modified)
  * Partial application (e.g., horizontal allowed, vertical rejected)
* Physics integration strategies:
  * Engine-driven physics resolution
  * Hybrid kinematic + physics enforcement
* All variants must preserve:
  * Single point of physical authority
  * Deterministic resolution order

#### 2.4.6 Temporal Characteristics
* Executes once per update cycle
  * After all motion intents are authored
  * After all motion proposals are produced
* Proposal appraisal and resolution occur atomically per cycle
* Physical actor state is mutated exactly once per cycle
* Observed state may be cached for subsequent cycles

#### 2.4.7 Extension & Substitution Surfaces
* Motion proposal formats
  * Custom proposal types (e.g., impulses, scripted motion)
* Resolution policies
  * Arbitration rules
  * Constraint handling strategies
* Physics backends
  * Alternative execution substrates
* Actor representations
  * Different abstract actor target models
* Substitution must not:
  * Introduce additional motion authorities
  * Bypass proposal-based resolution

#### 2.4.8 Non-Goals & Explicit Exclusions
* Does not:
  * Author motion intent
  * Interpret semantic meaning of motion
  * Consume raw input
  * Manage presentation concerns
* Does not:
  * Coordinate domain execution order
  * Perform cross-domain orchestration
* Is not:
  * A gameplay decision system
  * An animation controller

### 2.5 Presentation Model
Deferred.

## 3. Data Structures & Contracts

### 3.1 Design Goals & Constraints
Domains must remain composable

* Contracts should encourage semantic coupling, never structural
* All data-structures must be strongly-typed
* Runtime type-inference should be avoided, especially in hot-spots

### 3.2 Core Data Structures

#### 3.2.1 Intent-Bearing Input
* Semantic role:
  * Structured values
  * System-ready (I.e., formatted in way downstream consumers can digest)
  * Not explicitly semantic in terms of intent -> motion pipeline
* Information boundary:
* Lifecycle:
  * Evaluated exactly once per-cycle (at beginning of frame)
  * Remains immutable post-evaluation (consumers may only read and derive from)
* Stability expectation:
  * Contract may change with any downstream consumers expectation changes

#### 3.2.2 Reference-Basis
* Semantic role:
  * The reference-basis of currently active view-apparatus
* Information boundary:
* Lifecycle:
  * May change on-demand according to evironmental events
  * Downstream consumers only recieve one evaluated output per-cycle
    * Event handlers are not to alert consumers of update directly (consumers must subscribe to such an event)
  * Remains immutable post evaluation
* Stability expectation:
  * Contract may expand to cover multiple view-apparatus types (e.g. pure audio)

#### 3.2.3 Motion Intent
Deferred.

#### 3.2.4 Motion Proposal
Deferred.

#### 3.2.5 Physical Actor State
Deferred.

#### 3.2.6 Snapshot
Deferred.

### 3.3 Contractual Guarantees
Deferred.

### 3.4 Language & Engine Bindings
Deferred.

### 3.5 Non-Goals & Deferred Decisions
Deferred.

## 4. Composition & Wiring Strategy
Deferred.

## 5. Variability, Substitution, and Extension Points
Deferred.

## 6. Configuration & Authoring Model
Deferred.

## Links

* [README](../../README.md)
* [Design Doc — Introduction](./introduction.md)
* [Design Doc — Architecture](./architecture.md)
* [Design Doc — System Design (currently here)](./system_design.md)
* [Design Doc — Appendix](./appendix.md)