## Abstract Class. Defines contract for Locomotion Styles.
## Used for authoring locomotion semantics
## (via SemanticAction; I.e., "What does it mean to MOVE?", "What is FACE_FORWARD?").
## Extensions/edits should be made within existing/new concrete implementations.
class_name LocomotionStyle
extends RefCounted

# Using
const MotionState       := LocomotionSemantics.MotionState
const TemporalCharacter := MotionIntent.TemporalCharacter
const HorizontalIntent  := MotionIntent.Horizontal
const RotationalIntent  := MotionIntent.Rotational
const VerticalIntent    := MotionIntent.Vertical

## A flag representing if character is currently bounded to canonical reference basis look direction.
var bounded := false # "Is forward direction of character bounded to camera?"
var _locomotionState: LocomotionSemantics.State

func _init(locomotionState: LocomotionSemantics.State) -> void:
	_locomotionState = locomotionState

## Callable to obtain authored motion intents. Used by LocomotionSemantics in main pipeline.
func author() -> Array[MotionIntent]:
	assert(false, "Authoring must be implemented")
	return []

# Semantic Actions (used to author styles)
## Authors a rotational motion intent to express facing forward.
class FACE_FORWARD extends RefCounted:
	static func express(speed: float, yaw: float) -> RotationalIntent:
		return RotationalIntent.new(
			0,
			TemporalCharacter.IMPULSE,
			speed,
			yaw
		)

## Authors a horizontal motion intent to express continuous directional movement
class MOVE extends RefCounted:
	static func express(speed: float, direction: Vector2) -> HorizontalIntent:
		return HorizontalIntent.new(
			0,
			TemporalCharacter.CONTINUOUS,
			speed,
			direction
		)

## Authors a vertical motion intent to express discrete upward movement.
class JUMP extends RefCounted:
	static func express(acceleration: float) -> VerticalIntent:
		return VerticalIntent.new(
			0,
			TemporalCharacter.IMPULSE,
			acceleration
		)

# Utils
# Utils
func _JUMP_ENABLED() -> bool:
	return _locomotionState.config.JUMP_ENABLED

func _WHILE_STILL() -> bool:
	return _locomotionState.config.WHILE_STILL

func _WHILE_MOVING() -> bool:
	return _locomotionState.config.WHILE_MOVING

func _WHILE_AIRBORNE() -> bool:
	return _locomotionState.config.WHILE_AIRBORNE

func _WHILE_AIMING() -> bool:
	return _locomotionState.config.WHILE_AIMING

## Get current move direction intent relative to reference-basis.
func _get_move_direction() -> Vector3:
	# Derive direction from inputs based on camera direction
	var lateral_dir: Vector3 = _locomotionState.view_direction_x * _locomotionState.move_vector.x
	var forward_dir: Vector3 = _locomotionState.view_direction_z * -_locomotionState.move_vector.y
	
	# Return full directional vector
	return (lateral_dir + forward_dir).normalized()
