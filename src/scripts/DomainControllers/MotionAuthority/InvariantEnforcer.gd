class_name InvariantEnforcer
extends RefCounted

var _motionState: MotionAuthority.State

func _init(motionState: MotionAuthority.State) -> void:
	_motionState = motionState

func enforce(delta: float) -> void:
	# Apply non-negotiable invariants
	if _motionState.curr_motion_state == MotionAuthority.MotionState.AIRBORNE:
		_motionState.motionTarget.velocity += _motionState.motionTarget.get_gravity() * delta
