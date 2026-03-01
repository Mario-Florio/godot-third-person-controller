class_name ViewInterface
extends Node3D

# Abstract Class / Contract
# See CameraMount3D, FollowCameraMount3D, and FixedCameraMount3D for implementations

@export var view: Node3D
@export var viewArea: ViewArea

@onready var id: int = get_instance_id()

# Methods
## Activate view; make current
func activate() -> void:
	pass

## Deactivate view
func deactvate() -> void:
	pass

## Adjusts views pitch value (if available, otherwise function passes).
## Pitch value is applied to view in its physics process.
func adjust_pitch(_pitch: float) -> void:
	pass

## Adjusts views yaw value (if available, otherwise function passes).
## Yaw value is applied to view in its physics process.
func adjust_yaw(_yaw: float) -> void:
	pass

## Adjusts views position-z value (if available, otherwise function passes).
## Position-z value is applied to view in its physics process.
func adjust_position_z(_delta_z: float) -> void:
	pass

## Follow-camera mount method.
## Sets camera mounts is_zoomed value.
## Zoom application is applied within mounts physics process.
func set_is_zoomed(_is_zoomed: bool) -> void:
	pass

## Follow-camera mount method.
## Sets camera mounts is_flipped value.
## Flip application is applied within mounts physics process.
func set_is_flipped(_is_flipped: bool) -> void:
	pass