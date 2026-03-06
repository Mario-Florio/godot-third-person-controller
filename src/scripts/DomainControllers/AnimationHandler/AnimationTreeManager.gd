class_name AnimationTreeManager
extends RefCounted

var _animationState : AnimationHandler.State
var _animationTree  : AnimationTree

func _init(animationState: AnimationHandler.State, animationTree: AnimationTree) -> void:
	_animationState = animationState
	_animationTree = animationTree

func manage(payload: AnimationHandler.Payload) -> void:
	_animationTree.set(_animationState.config.is_grounded_path, _animationState.is_grounded)
	_animationTree.set(_animationState.config.is_airborne_path, _animationState.is_airborne)
	
	_animationTree.set(
		_animationState.config.grounded_blend_position_path,
		payload.local_velocity *
			((payload.speed / payload.max_horizontal_speed) * 1.0)
	)
	
	_animationTree.set(
		_animationState.config.airborne_blend_position_path,
		payload.local_velocity *
			((payload.speed / payload.max_horizontal_speed) * 1.0)
	)

func setAnimationTree(animationTree: AnimationTree) -> void:
	_animationTree = animationTree
