# Godot Third-Person Controller
A general-purpose third-person controller for Godot 4.

## Overview

This project provides a configurable and extensible framework for basic third-person character control. It is designed to serve as a foundation for games or prototyping that requires customizable character mechanics.

**Key goals:**

* Provide a reliable foundation for third-person controller mechanics
* Maintain architectural flexibility that leaves select systems open for extension (e.g. *locomotion-style*, *controller-domains*, etc.)

## Documentation

For further information, see the following resources:

* [***Setup Guide***](./docs/setup_guide/setup_guide.md) — A guide to help with installation and setup
* [***Introduction***](./docs/design_doc/introduction.md) — A brief introduction to the projects purpose, scope, and approach
* [***Architecture***](./docs/design_doc/architecture.md) — Arituculation of projects architecural model
* [***System Design***](./docs/design_doc/system_design.md) — Technical breakdown of architecture and system-design

## Limitations

Controller does not currently support:

* Advanced locomotion & motion
* Root motion

See [*Known Contraints & Tradeoffs*](/docs/design_doc/introduction.md#5-known-constraints--tradeoffs) for further discussion on current limitations.

## Contributing

This project is open source and freely forkable.  

Development is primarily driven by the original author.

Pull requests are accepted selectively and only when they align with the project’s scope and architectural direction.

## License

[MIT](/LICENSE) – see *LICENSE* file for details.
