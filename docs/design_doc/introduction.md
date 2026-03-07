# Godot Third-Person Controller (v1) — Introduction

**Index**

- [Godot Third-Person Controller (v1) — Introduction](#godot-third-person-controller-v1--introduction)
  - [1. Problem Statement](#1-problem-statement)
    - [1.1 Gap in the Godot Ecosystem](#11-gap-in-the-godot-ecosystem)
    - [1.2 The Cost of a Controller](#12-the-cost-of-a-controller)
  - [2. Solution Overview](#2-solution-overview)
    - [2.1 Reusable Foundation](#21-reusable-foundation)
    - [2.2 Self-Contained System](#22-self-contained-system)
    - [2.3 Extensible Architecture \& Modular Interfaces](#23-extensible-architecture--modular-interfaces)
    - [2.4 Production-Oriented Design](#24-production-oriented-design)
  - [3. Scope](#3-scope)
    - [3.1 In-Scope](#31-in-scope)
      - [3.1.1 Core Control Mechanics](#311-core-control-mechanics)
      - [3.1.2 Basic Locomotion/Motion](#312-basic-locomotionmotion)
      - [3.1.3 Rudimentary Animation System](#313-rudimentary-animation-system)
    - [3.2 Out of Scope](#32-out-of-scope)
      - [3.2.1 Advanced Locomotion/Motion](#321-advanced-locomotionmotion)
      - [3.2.2 Robust Animation System](#322-robust-animation-system)
  - [4. Design Philosophy \& Approach](#4-design-philosophy--approach)
    - [4.1 Architectural Doctrine](#41-architectural-doctrine)
      - [4.1.1 Structural Clarity](#411-structural-clarity)
      - [4.1.2 Hard Modularity](#412-hard-modularity)
      - [4.1.3 First-Class Extensibility](#413-first-class-extensibility)
      - [4.1.4 Architectural Foresight](#414-architectural-foresight)
    - [4.2 Constraint Principles](#42-constraint-principles)
      - [4.2.1 Performance](#421-performance)
      - [4.2.2 Architectural Observability](#422-architectural-observability)
      - [4.2.3 System Transparency \& Ownership](#423-system-transparency--ownership)
  - [5. Known Constraints \& Tradeoffs](#5-known-constraints--tradeoffs)
    - [5.1 Input Mapping](#51-input-mapping)
    - [5.2 Godot Engine Coupling](#52-godot-engine-coupling)
  - [6. Next Steps](#6-next-steps)
  - [Links](#links)

**Links**

* [README](../../README.md)
* [Design Doc — Introduction (currently here)](./introduction.md)
* [Design Doc — Architecture](./architecture.md)
* [Design Doc — System Design](./system_design.md)
* [Design Doc — Appendix](./appendix.md)

---

## 1. Problem Statement

### 1.1 Gap in the Godot Ecosystem
Godot provides low-level physics bodies, scene composition tools, and scripting APIs suitable for constructing character controllers. However, it does not ship with a first-party, general-purpose third-person controller comparable in scope to [Unity's Third Person Starter Asset](https://assetstore.unity.com/packages/essentials/starter-assets-thirdperson-updates-in-new-charactercontroller-pa-196526#description) or [Unreal's Third Person Template](https://dev.epicgames.com/documentation/en-us/unreal-engine/third-person-template-in-unreal-engine).

Community-maintained and commercial controllers are available. These typically address specific gameplay styles or project needs rather than functioning as a modular, configurable reference implementation intended for broad reuse and incremental refinement. As a result, third-person controller systems often require reimplementation across projects.

### 1.2 The Cost of a Controller
A character controller is foundational gameplay technology rather than a peripheral feature. It mediates player input, state transitions, animation playback, camera interaction, and physical motion. As such, it can become deeply coupled to multiple subsystems early in development.

Because of this coupling, replacing or rewriting a controller mid-project is costly. Animation graphs, camera rigs, collision handling, and gameplay mechanics often evolve around early controller assumptions. Architectural weaknesses in the initial implementation can therefore propagate outward as the project scales.

Despite variation in genre and mechanics, most controllers solve a common set of structural problems: translating raw user input into semantic character intent, and realizing that intent under physical and gameplay constraints. These recurring abstractions suggest that controller design benefits from deliberate architecture rather than ad hoc implementation.

## 2. Solution Overview
The proposed solution is an open-source, general-purpose third-person controller characterized by:

* a reusable foundation
* self-contained functionality
* extensible architecture
* production-oriented design

### 2.1 Reusable Foundation
A general-purpose controller should address structural patterns common across third-person games without embedding genre-specific assumptions. Core movement, state handling, and configuration should remain broadly applicable, avoiding hard-coded behaviors that restrict reuse.

The system should provide sensible defaults while isolating non-universal functionality so that projects can adapt the controller without modification of core logic.

### 2.2 Self-Contained System
The controller is designed as an independent unit that can be integrated with minimal scaffolding. Core functionality should not depend on external frameworks or project-specific infrastructure beyond required engine primitives. Such a system reduces integration overhead and clarifies architectural boundaries.

### 2.3 Extensible Architecture & Modular Interfaces
Broad applicability requires that the controller remain open to extension. The system should expose defined extension surfaces and maintain internal separation of concerns so that additional behaviors can be layered without rewriting core components.

Modularity enables integration with external systems (e.g., gameplay logic, abilities, AI) while preserving the integrity of foundational controller logic.

### 2.4 Production-Oriented Design
The controller is intended for use beyond prototypes. It should remain stable under expected gameplay load, avoid hidden coupling, and behave predictably under edge conditions.

Internal complexity should be encapsulated while remaining observable through controlled interfaces, enabling debugging, testing, and performance profiling. Failure states should be explicit and diagnosable rather than silent or ambiguous.

## 3. Scope
This section defines the functional and architectural boundaries of the version 1 release. Scope is intentionally limited to foundational responsibilities.

### 3.1 In-Scope

#### 3.1.1 Core Control Mechanics
Core controller mechanics form the foundation of all adjunct features. Without this foundation there is no controller. These core mechanics can be understood through the foundational responsiblities that make up the *intent -> realization pipeline*:

* Input Interface
* View-Intent Mediation
* Intent Resolution
* Realization Authority

This pipeline is responsible for consuming player intent and realizing it into character action. For more information, see [Architecture](/docs/design_doc/architecture.md).

#### 3.1.2 Basic Locomotion/Motion
Current features will center around realization of basic locomotion and motion. The controller will be capable of:

* camera-relative directional movement
* speed variation
* basic environment-independent locomotion actions (e.g. jump, dash, lift)
* grounded vs airborne state handling
* basic constraint control (e.g. horizontal intent while airborne)
* configurability of motion physics

#### 3.1.3 Rudimentary Animation System
While not directly related to core controller functionality, a rudimentary animation system will be included to complete the pipeline with presentation of core features. This system will allow for visual representation of core mechanics:

* character states (e.g. grounded, airborne)
* speed variation (e.g. walking, running)

### 3.2 Out of Scope

#### 3.2.1 Advanced Locomotion/Motion
Advanced locomotion and motion systems are excluded. While the architecture permits extension, locomotion beyond humanoid styles are not implemented in v1. Traversal mechanics, terrain adaptation systems, and context-aware collision response are explicitly deferred.

#### 3.2.2 Robust Animation System
The animation layer is intentionally minimal and not designed as a generalized animation framework. A baseline animation system is included for visualization of controller states, but no animation library is provided and root-motion support is not established.

## 4. Design Philosophy & Approach
The follow section describes governing principles for the project, not implementation guarantees. This section should be used to guide architectural decisions and system implementation.

### 4.1 Architectural Doctrine

#### 4.1.1 Structural Clarity
Systems are organized hierarchically with progressive disclosure of implementation detail. High-level modules orchestrate domain behavior—lower-level modules implement mechanics within clearly defined responsibility boundaries.

Abstraction layers must reflect meaningful authority ownership, dependency direction, and scope of responsibility. Architecture should support top-down exploration without premature exposure to low-level details. Module placement and naming must make system structure predictable and navigable.

**Key Properties:**
* Hierarchical organization aligned to domain boundaries
* Clear orchestration vs implementation separation
* Progressive disclosure of detail
* Predictable structural navigation

#### 4.1.2 Hard Modularity
Modules and subsystems must maintain strict responsibility boundaries. Each unit owns the state and behavior relevant to its domain and interacts with other units only through explicit contracts.

Dependency direction must be intentional and enforced. Structural coupling between peer systems is prohibited; dependency inversion is used where appropriate to preserve boundaries. Units should be able execute in isolation when provided with contract-conforming dependencies.

Semantic coupling is inevitable in cohesive systems; structural coupling is not. Refactors that require widespread structural modification (e.g., shotgun surgery) indicate boundary violations.

**Key Properties:**
* Strong separation of concerns
* Enforced responsibility ownership
* Isolation capability via explicit contracts
* Minimized structural coupling

#### 4.1.3 First-Class Extensibility
Architecture must expose deliberate and controlled extension surfaces. Extension points correspond to genuine axes of variation within the domain, not speculative abstraction.

Core logic remains isolated from extension mechanisms. Additional behavior should be introducible through defined contracts without modification of existing core systems.

Public extension surfaces must remain stable and predictable to support downstream customization and forking.

**Key Properties:**
* Explicit extension contracts
* Alignment with real domain variation
* Open/Closed compliance in core systems
* Stable and predictable extension surface

#### 4.1.4 Architectural Foresight
Upfront domain modeling and principled abstraction are preferred over expedient implementations. Structural integrity and long-term clarity take precedence over localized simplicity when architectural concerns are at stake.

Abstractions are introduced when they clarify responsibility boundaries or represent expected variation within the system. They are assumed acceptable unless constrained by measurable runtime cost or other non-functional requirements.

Structural decisions are reviewed iteratively, and abstractions are simplified or specialized when constraints justify doing so.

**Key Properties:**
* Preference for principled domain modeling
* Abstractions aligned to responsibility or variation
* Architecture-first implementation strategy
* Constraint-driven refinement

### 4.2 Constraint Principles

#### 4.2.1 Performance
Runtime behavior must remain predictable. Per-cycle execution is baseline. On-demand paths must not violate its predictability.

Runtime cost must scale in a controlled, bounded manner. Allocation must not introduce hidden instability.

**Key Properties:**
* Deterministic per-cycle execution
* Bounded runtime cost
* Controlled allocation in performance-critical paths

#### 4.2.2 Architectural Observability
Intermediate states and state transitions must be discrete and inspectable without invasive modification of core logic. Debugging and validation should be supported through architectural design rather than ad hoc instrumentation.

**Key Properties:**
* Explicit intermediate states
* Non-invasive inspection capability

#### 4.2.3 System Transparency & Ownership
Architecture must be legible without hidden framework behavior. Users should be able to trace control flow and responsibility boundaries directly from source. Modification and forking are anticipated use cases.

**Key Properties:**
* Legible control flow
* Clear responsibility boundaries
* Encouraged source ownership

## 5. Known Constraints & Tradeoffs

### 5.1 Input Mapping
The current release only contains pre-configured support for mouse & keyboard. While extended support is anticipated, current development is focused on establishing core controller mechanics.

### 5.2 Godot Engine Coupling
The current implementation does not utilize adapters between Godot Engine components (e.g., `CharacterBody3D`) and core logic. While not a major concern since this project targets the Godot runtime specifically, future iterations will consider proper isolation of core controller mechanics from unmanaged engine components.

## 6. Next Steps
Deferred.

## Links

* [README](../../README.md)
* [Design Doc — Introduction (currently here)](./introduction.md)
* [Design Doc — Architecture](./architecture.md)
* [Design Doc — System Design](./system_design.md)
* [Design Doc — Appendix](./appendix.md)