class_name CameraConfig
extends Resource

@export_range(0.0, 1.0) var horizontal_sensitivity := 0.30
@export_range(0.0, 1.0) var vertical_sensitivity   := 0.30

@export_group("Follow Camera")
## Default view distance from character.
@export_range(0.0, 5.0) var DEFAULT_SPRING_ARM_LENGTH := 1.50

## Focused view distance from character.
@export_range(0.0, 5.0) var FOCUSED_SPRING_ARM_LENGTH := 0.80

## Horizontal camera offset from character.
@export_range(-2.0, 2.0) var DEFAULT_SPRING_ARM_POSITION_X := 0.00

## Vertical camera offset from character.
@export_range(0.0, 1.0) var DEFAULT_SPRING_ARM_POSITION_Y := 0.00
