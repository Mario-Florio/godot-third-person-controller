# Godot Third-Person Controller (v1) — Architecture

**Index**

- [Godot Third-Person Controller (v1) — Architecture](#godot-third-person-controller-v1--architecture)
  - [1. Architectural Intent](#1-architectural-intent)
  - [2. What Is a Controller?](#2-what-is-a-controller)
    - [2.1 A Third-Person Controller](#21-a-third-person-controller)
  - [3. Responsibilities](#3-responsibilities)
    - [3.1 Core / Foundational](#31-core--foundational)
      - [3.1.1 Input Interface](#311-input-interface)
      - [3.1.2 View-Intent Mediation](#312-view-intent-mediation)
      - [3.1.3 Intent Resolution](#313-intent-resolution)
      - [3.1.4 Realization Authority](#314-realization-authority)
    - [3.2 Expected Adjacent Responsibilites](#32-expected-adjacent-responsibilites)
      - [3.2.1 Presentation Mediation](#321-presentation-mediation)
    - [3.3 Boundaries \& Ownership](#33-boundaries--ownership)
  - [4. Data, State, and Flow](#4-data-state-and-flow)
    - [4.1 Data Categories](#41-data-categories)
    - [4.2 State Ownership](#42-state-ownership)
    - [4.3 Data Flow](#43-data-flow)
      - [4.3.1 Intent-Bearing Input](#431-intent-bearing-input)
      - [4.3.2 Reference-Basis](#432-reference-basis)
      - [4.3.3 Semantic Intent](#433-semantic-intent)
      - [4.3.4 Physical Actor State](#434-physical-actor-state)
  - [5. Composition Model](#5-composition-model)
    - [5.1 Responsibility Composition](#51-responsibility-composition)
    - [5.2 Intent -\> Realization Pipeline](#52-intent---realization-pipeline)
    - [5.3 Authority Boundaries](#53-authority-boundaries)
    - [5.4 Variability \& Substitution](#54-variability--substitution)
  - [6. Architectural Non-Goals](#6-architectural-non-goals)
    - [6.1 This Architecture Does Not Specify](#61-this-architecture-does-not-specify)
    - [6.2 This Architecture Is Not Optimized For](#62-this-architecture-is-not-optimized-for)
    - [6.3 Explicitly Deferred Concerns](#63-explicitly-deferred-concerns)
    - [6.4 Misinterpretations to Avoid](#64-misinterpretations-to-avoid)
  - [Links](#links)

**Links**

* [README](../../README.md)
* [Design Doc — Introduction](./introduction.md)
* [Design Doc — Architecture (currently here)](./architecture.md)
* [Design Doc — System Design](./system_design.md)
* [Design Doc — Appendix](./appendix.md)

---

## 1. Architectural Intent
All controllers must solve the problem of mapping input intent to realized actions. Given this common problem, dedicated architecure is useful to derive universal solutions.

Architecture exists to:
* Define core responsibilities
* Separate concerns cleanly
* Establish firm boundaries
* Prevent coupling to early decision
* Make design universal as opposed to ad hoc

## 2. What Is a Controller?
A controller is a piece of technology which resolves user intent into abstract actor action. It serves as a:

* A reference-basis from which intent can be translated into action 
* An interface that handles decisions in regard to character-control/interaction mechanics (computational model)
* A system that manages state related to real-time interaction in a closed system (stateful model)

### 2.1 A Third-Person Controller
A third-person controller is a controller whose:

* Reference-basis is not directly situated within the abstract actor
* Interface informs abstract actor behavior
* State effects abstract actor action & outcomes

## 3. Responsibilities
Architectural abstractions common to controller mechanics.

| Responsibility | Description | Mandatory / Optional |
| --- | --- | --- |
| **Input Interface** | System ingress point | Mandatory |
| **View-Intent Mediation** | View and reference-basis provider | Mandatory |
| **Intent Resolution** | Semantic interpreter of intent | Mandatory |
| **Realization Authority** | Authoritative realization resolver | Mandatory |
| **Presentation Mediation** | Presenter of controller mechanics | Optional |

### 3.1 Core / Foundational
Mandatory responsibilities.

#### 3.1.1 Input Interface
* Serves as the ingress point
* Provides a surface for control-relevant signals to be recieved
* Organizes and structures input in formats the system can begin to digest

#### 3.1.2 View-Intent Mediation
* Maintain and expose a spatial frame of reference that informs player intent and orientation
* Defining and mediating the reference basis from which intent is intrepeted and interaction occurs

#### 3.1.3 Intent Resolution
* Resolve raw intent into semantic intent
* Determines meaningful action within specialized domains
* Interpret intent as coherent abstract actor actions

#### 3.1.4 Realization Authority
* Arbitrate what intent may be realized (or not) based on given constraints
* Decide how physical action is actually realized
* Enforce physical invariants & constraints

### 3.2 Expected Adjacent Responsibilites
Not core, but architecturally anticipated/expected adjunct responsibilities. Optional.

#### 3.2.1 Presentation Mediation
* Expose controller state in a form suitable for visual representation

### 3.3 Boundaries & Ownership
Boundaries and ownership of each responsibility. Used for determining separation of behavior and data.

| Responsibility | Owns | Responsible For | Not Responsible For |
| --- | --- | --- | --- |
| **Input Interface** | Input surfaces | Preparing control-relevant signals for system-wide digestion | Resolving semantic intent |
| **View-Intent Mediation** | Canonical reference-basis; view-apparatus' | View apparatus management and reference-basis provisions | Determining semantic intent related to reference-basis |
| **Intent Resolution** | Intent interpretation | Authoring semantic intent; Semantic filtering of intent | Realizing intent into action |
| **Realization Authority** | Physics invariants & constraints; abstract actor | Realizing semantic intent into physical action | Determining semantic permissions or visualizing action |
| **Presentation Mediation** | Presentation | Provide visual representation of controller mechanics | Controller mechanics |

## 4. Data, State, and Flow

### 4.1 Data Categories
Abstract data categories associated with responsibility communication.

| Category | Description | Produced By | Consumed By | Derived From |
| --- | --- | --- | --- | --- |
| **Intent-bearing Input** | Unrefined input prepared for system-consumption or further specialized resolution | Input Interface | View-Intent Mediation; Intent Resolution | Control-relevant signals |
| **Reference-basis** | State related to the canonical reference-basis, including view-apparatus | View-intent Mediation | Intent Resolution | Intent-bearing input |
| **Semantic Intent** | Intent which expresses meaningful action | Intent Resolution | Realization Authority | Intent-bearing input; Reference-basis |
| **Physical Actor State** | Actual state of abstract actor | Realization Authority | Intent Resolution; Presentation Mediation | Abstract actor |

### 4.2 State Ownership
*Responsibilities x Data Category relationships:*

| Responsibility | Authoritative Over | Depends On |
| --- | --- | --- |
| **Input Interface** | Intent-bearing Input | Control-relevant signals |
| **View-Intent Mediation** | Reference-Basis | Intent-bearing Input |
| **Intent Resolution** | Semantic Intent | Intent-bearing Input; Reference-basis |
| **Realization Authority** | Physical Actor State | Intent-bearing input; Semantic Intent; Reference-basis |
| **Presentation Mediation** | None | None | Physical Actor State |

### 4.3 Data Flow
Data flows through responsibilities. Responsibilities consume data to derive mutations to owned domain state, or produce further developments to consumed data for later downstream consumers.

```
(Control-relevant signals)          (Prev cycle:
            |                           Physical actor state)
            v
+-----------------------------+                 |
|       Input Interface       |                 |
+-----------------------------+                 |
            |                                   |
    (Intent-bearing input)                      |
            |                                   |
            |   +-----------------------------+ |
            +-->|    View-Intent Mediation    | |
            |   +-----------------------------+ |
            |       |                           |
            |   (Reference-basis)               |
            |       |                           v
            |       |   +------------------------------+
            +-------+-->|      Intent Resolution       |
            |       |   +------------------------------+
            |       |                   |
            |       |           (Semantic intent)
            |       |                   v
            |       |   +------------------------------+
            +-------+-->|    Realization Authority     |
                        +------------------------------+
                                       |
                                       v
                            (Physical actor state)
```

>Note: Implementation is subject to change. The above model represents a possible instantiation of the pipelines data flow. Future iterations are not bound to this model. For an abstract, implementation agnostic model, see [section 5.2](#52-intent---realization-pipeline).

#### 4.3.1 Intent-Bearing Input

| Intent-bearing input examples -> | Consumer -> | Output |
| --- | --- | --- |
| View discovery; Mouse-motion | View-Intent Mediation | Reference-basis | 
| Move direction; actions | Intent Resolution | Semantic intent |
| Floor-detection | Realization Authority | Physical actor state |

#### 4.3.2 Reference-Basis

| Reference-basis examples -> | Consumer -> | Output |
| --- | --- | --- |
| Yaw; location | Intent Resolution | Semantic intent |
| Location | Realization Authority | Physical actor state |

#### 4.3.3 Semantic Intent

| Semantic intent examples -> | Consumer -> | Output |
| --- | --- | --- |
| Motion intent | Realization Authority | Physical actor state |

#### 4.3.4 Physical Actor State

| Physical actor state examples -> | Consumer -> | Output |
| --- | --- | --- |
| Motion state | Intent Resolution | Bounded state |
| Local velocity | Presentation Mediation | Visual interpretation |

## 5. Composition Model

### 5.1 Responsibility Composition
A controller is composed of:

* Responsibilities which encapsulate duty, state, and authority
* A structured intent → realization data-processing pipeline

Responsibilities are cohesive units participating in the intent → realization pipeline:

* Input Interface — raw, externally-sourced input → intent-bearing input
* View-Intent Mediation — intent-bearing input → reference-basis state
* Intent Resolution — intent-bearing input → semantic intent
* Realization Authority — semantic intent → physical actor state

Core responsibilities are structurally mandatory. Adjunct responsibilities are optional and exist to increase presentation quality.

Responsibilities communicate via explicit data contracts, without mutating peer domain state or depending on peer structure.

**Composition requires explicit wiring of responsibility inputs and outputs.** Composition assumes:

* *Intent -> realization pipeline* is preserved
* Communication contracts are maintained

### 5.2 Intent -> Realization Pipeline
The intent-realization pipeline produces progressive semantic development of data:

1. Control-relevant signal
2. Intent-bearing input
3. Reference-basis
4. Semantic Intent
5. Physical actor state

```
               1. Control-relevant
                     signals
                        |
                        v
                +-----------------+
                | Input Interface |
                +-----------------+
                         |
                2. Intent-bearing
                       input
                         |
                     +---+---+
                     |       |
                     v       v
+-----------------------+ +-------------------+
| View-Intent Mediation | | Intent Resolution |
+-----------------------+ +-------------------+
            |                   |
    3. Reference-basis   4. Semantic intent
            |                   |
            v                   v
        +-----------------------------+
        |    Realization Authority    |
        +-----------------------------+
                        |
                5. Physical actor
                      state
                        |
                        v
```
>Note: Diagram does not represent strict data flow, but linear progression of data development.

### 5.3 Authority Boundaries
Deferred.

### 5.4 Variability & Substitution
Deferred.

## 6. Architectural Non-Goals
Deferred.

### 6.1 This Architecture Does Not Specify
Deferred.

### 6.2 This Architecture Is Not Optimized For
Deferred.

### 6.3 Explicitly Deferred Concerns
Deferred.

### 6.4 Misinterpretations to Avoid
Deferred.

## Links

* [README](../../README.md)
* [Design Doc — Introduction](./introduction.md)
* [Design Doc — Architecture (currently here)](./architecture.md)
* [Design Doc — System Design](./system_design.md)
* [Design Doc — Appendix](./appendix.md)