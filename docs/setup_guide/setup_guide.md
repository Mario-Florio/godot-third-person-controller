# Setup Guide

**Index:**

- [Setup Guide](#setup-guide)
  - [Requirements](#requirements)
  - [Installation](#installation)
    - [Clone Repository](#clone-repository)
    - [Download Release](#download-release)
  - [Getting Started](#getting-started)
  - [Basic Setup](#basic-setup)
    - [Character Body](#character-body)
    - [Follow Camera](#follow-camera)
  - [Dynamic View Discovery](#dynamic-view-discovery)
    - [Setup](#setup)
    - [Testing Multiple Views](#testing-multiple-views)
  - [Position Configuration](#position-configuration)
    - [Setup](#setup-1)
    - [Visuals (optional but recommended)](#visuals-optional-but-recommended)
  - [ThirdPersonCharacter Scene](#thirdpersoncharacter-scene)
    - [Setup](#setup-2)
  - [Animation System](#animation-system)

## Requirements

* Godot Engine 4.5+

---

## Installation

### Clone Repository

```bash
git clone https://github.com/mario-florio/godot-third-person-controller.git
```

### Download Release

Download the latest release:

[Download v0.3.0](https://github.com/Mario-Florio/godot-third-person-controller/archive/refs/tags/v0.3.0.zip)

Or browse all releases:

[https://github.com/Mario-Florio/godot-third-person-controller/releases](https://github.com/Mario-Florio/godot-third-person-controller/releases)

---

## Getting Started

1. Open `Test.tscn` located in:

```
godot-third-person-controller/src/scenes/
```

2. Run the scene using **Run Current Scene** in the Godot editor or press:

```
F6
```

---

## Basic Setup

Minimal preparation for:

* camera handling
* directional movement
* jumping

---

### Character Body

1. Add a `CharacterBody3D` node to your scene (with child `CollisionShape3D`, **Shape** property assigned).
2. Add any `Node3D` as a child to the parent `CharacterBody3D` node (see `/godot-third-person-controller/assets/resources/visuals/mesh/` for provided visuals). 
3. Add the `ThirdPersonController` node as a child of the `CharacterBody3D`.
4. Select the `ThirdPersonController` node and *assign* the parent `CharacterBody3D` to the **Character Body** property in the *Inspector Dock*.

>Configurations can be made to the controller by selecting the `ThirdPersonCharacter` node and editing the **Third Person Controller Config** (see `/godot-third-person-controller/assets/resources/config/presets/` for preconfigured sets)

---

### Follow Camera

1. Add the `FollowCameraMount` scene from:

```
godot-third-person-controller/src/scenes/
```

2. Select the `FollowCameraMount` node and *assign* the `CharacterBody3D` to the **Follow Target** property.

3. Select the `ThirdPersonController` node and *assign* the `FollowCameraMount` to the **Initial View** property in the *Inspector Dock*.

> **Important:**
> `FollowCameraMount` must **not** be a child of the `Follow Target`.
> Doing so will create rotation conflicts between the camera and the character body.

>Configurations can be made to the follow camera by selecting the `FollowCameraMount` node and editing the **Camera Config** (see `/godot-third-person-controller/assets/resources/config/presets/` for preconfigured sets)

---

## Dynamic View Discovery

Adds support for automatically discovering camera views.

>This section assumes **Basic Setup** is already completed.

### Setup

1. Add the `ViewProbe` scene as a child of the `CharacterBody3D`.
2. Select the `ThirdPersonController` node and *assign* the `ViewProbe` to the **View Probe** property in the *Inspector Dock*.

### Testing Multiple Views

To test view discovery:

1. Add any number of `FixedCameraMount` scenes to the current scene.
2. Each mount will automatically register when the player enters its view area.

> `Initial View` is optional when using dynamic discovery.
> `Follow Target` is still required for `FollowCameraMount`.

---

## Position Configuration

Adds support for positional configuration of collision body (optionally visuals).

>This section assumes **Basic Setup** is already completed.

### Setup

1. Select the `ThirdPersonController` node and *assign* the sibling `CollisionBody3D` to the **Collision Body** property in the *Inspector Dock*.

### Visuals (optional but recommended)

1. Select the `ThirdPersonController` node and *assign* the `Node3D` to the **Visuals** property in the *Inspector Dock*.

>Controller will function without visuals assigned. However, visuals will not align with the collision body.

---

## ThirdPersonCharacter Scene

The `ThirdPersonCharacter` scene provides a preconfigured character to reduce setup friction.
It includes:

* camera handling
* basic movement
* dynamic view discovery support
* position configurability

### Setup

1. Add the `ThirdPersonCharacter` scene to your level.
2. Add a `ThirdPersonController` node as a child of `ThirdPersonCharacter`.
3. Select the `ThirdPersonCharacter` node and *assign* the child `ThirdPersonController` to the **Controller** property.
4. Add a `FollowCameraMount` scene to the level.

See **Follow Camera** in [Basic Setup](#follow-camera) for camera setup.

## Animation System
(Coming Soon)