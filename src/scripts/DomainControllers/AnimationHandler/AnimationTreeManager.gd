class_name AnimationTreeManager
extends RefCounted

var _is_grounded_path: StringName
var _is_airborne_path: StringName

var _airborne_blend_position_path: StringName
var _grounded_blend_position_path: StringName

var _animationState : AnimationHandler.State
var _animationTree  : AnimationTree

func _init(animationState: AnimationHandler.State, animationTree: AnimationTree) -> void:
	_animationState = animationState
	_animationTree = animationTree
	
	_is_grounded_path = _animationState.config.is_grounded_path
	_is_airborne_path = _animationState.config.is_airborne_path
	
	_grounded_blend_position_path = _animationState.config.grounded_blend_position_path
	_airborne_blend_position_path = _animationState.config.airborne_blend_position_path

func manage(payload: AnimationHandler.Payload) -> void:
	_animationTree.set(_is_grounded_path, _animationState.is_grounded)
	_animationTree.set(_is_airborne_path, _animationState.is_airborne)
	
	_animationTree.set(
		_grounded_blend_position_path,
		payload.local_velocity *
			((payload.speed / payload.max_horizontal_speed) * 1.0)
	)
	
	_animationTree.set(
		_airborne_blend_position_path,
		payload.local_velocity *
			((payload.speed / payload.max_horizontal_speed) * 1.0)
	)
