## Abstract Class for semantic Motion Intents.
## Contains shared initialization logic.
## Used by Intent Resolution to author semantic intent for Realization Authority.
class_name MotionIntent
extends RefCounted

enum TemporalCharacter { IMPULSE, CONTINUOUS }

var priority: int
var temporality: TemporalCharacter
var magnitude: float # [0,1]

func _init(_priority: int, _temporality: TemporalCharacter, _magnitude: float) -> void:
	priority = _priority
	temporality = _temporality
	magnitude = clamp(_magnitude, 0.0, 1.0)

# Concrete Classes

## Horizontal implementation of MotionIntent.
## Defines a horizontal directional intent.
class Horizontal extends MotionIntent:
	var direction: Vector2
	
	func _init(_priority: int, _temporality: TemporalCharacter, _magnitude: float, _direction: Vector2) -> void:
		super(_priority, _temporality, _magnitude)
		direction = _direction

## Rotational implementation of MotionIntent.
## Defines a rotational turn intent.
class Rotational extends MotionIntent:
	var yaw: float
	
	func _init(_priority: int, _temporality: TemporalCharacter, _magnitude: float, _yaw: float) -> void:
		super(_priority, _temporality, _magnitude)
		yaw = _yaw
