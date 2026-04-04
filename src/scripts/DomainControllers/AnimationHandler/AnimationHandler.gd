class_name AnimationHandler
extends RefCounted

class State extends RefCounted:
	# System Context
	var config    : AnimationConfig
	var tracerAPI : TracerAPI
	
	var is_grounded: bool
	var is_airborne: bool
	
	func _init(_config: AnimationConfig, _tracerAPI: TracerAPI) -> void:
		config = _config
		tracerAPI = _tracerAPI

var _animationState: State
var _animationTreeManager: AnimationTreeManager

func _init(config: AnimationConfig, tracerAPI: TracerAPI, animationTree: AnimationTree) -> void:
	_animationState = State.new(config, tracerAPI)
	_animationTreeManager = AnimationTreeManager.new(_animationState, animationTree)

func execute(payload: AnimationHandler.Payload) -> void:
	var span_token := _animationState.tracerAPI.START_SPAN(Observability.SpanNames.ANIMATION_HANDLER_EXECUTE)
	
	_update_state(payload)
	_animationTreeManager.manage(payload)
	
	_animationState.tracerAPI.END_SPAN(span_token)

func setAnimationTree(animationTree: AnimationTree) -> void:
	_animationTreeManager.setAnimationTree(animationTree)

# Utils
func _update_state(payload: AnimationHandler.Payload) -> void:
	match payload.motionState:
		"STILL": # STILL implies grounded in current implementation
			_animationState.is_grounded = true
			_animationState.is_airborne = false
		
		"GROUNDED":
			_animationState.is_grounded = true
			_animationState.is_airborne = false
		
		"AIRBORNE":
			_animationState.is_grounded = false
			_animationState.is_airborne = true
		
		_:
			assert(false, "Intent mismatch [AnimationHandler._update_state]")

class Payload:
	var motionState: StringName
	var local_velocity: Vector2
	var max_horizontal_speed: float
	var speed: float
	
	func _init(
		_motionState: StringName,
		_local_velocity: Vector2,
		_max_horizontal_speed: float,
		_speed: float
	) -> void:
		
		motionState = _motionState
		local_velocity = _local_velocity
		max_horizontal_speed = _max_horizontal_speed
		speed = _speed
