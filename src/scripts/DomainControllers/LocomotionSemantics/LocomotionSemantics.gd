class_name LocomotionSemantics
extends RefCounted

enum Style { BIPED, OTS, TRAD }
enum SpeedTier { SLOW, NORMAL, FAST, REDLINE }
enum WorldState { CASUAL, ENGAGED, ALERT }
enum MotionState { STILL, GROUNDED, AIRBORNE }

class State extends RefCounted:
	# System Context
	var config    : LocomotionConfig
	var tracerAPI : TracerAPI
	
	var speed_multiplier : float
	var intents          : Array[MotionIntent] = []
	
	# Intent-bearing Input
	var move_vector := Vector2.ZERO
	var is_focused  := false
	var speedTier   := SpeedTier.NORMAL
	var worldState  := WorldState.ENGAGED
	var jump        := false
	var dash        := false
	var lift        := false
	
	# Reference Basis
	var view_rotation_y  := 0.0
	var view_direction_x := Vector3.ZERO
	var view_direction_z := Vector3.ZERO
	
	# Physical Actor State
	var motionState := MotionState.STILL
	
	func _init(_config: LocomotionConfig, _tracerAPI: TracerAPI) -> void:
		config = _config
		tracerAPI = _tracerAPI

var _locomotionState : State
var _locomotionStyle : LocomotionStyle
var _speed_vector    : Array[float]

func _init(config: LocomotionConfig, tracerAPI: TracerAPI) -> void:
	_locomotionState = State.new(config, tracerAPI)
	_locomotionStyle = _getStyle(config.STYLE)

func execute(payload: Payload) -> void:
	var span_token := _locomotionState.tracerAPI.START_SPAN(Observability.SpanNames.LOCOMOTION_SEMANTICS_EXECUTE)
	
	_update_state(payload)
	_locomotionState.intents = _locomotionStyle.author()
	
	_locomotionState.tracerAPI.ADD_EVENT(
		span_token,
		Observability.EventNames.MOTION_INTENTS_AUTHORED,
		{
			TraceFacade.AttributeNames.AMOUNT: _locomotionState.intents.size(),
			TraceFacade.AttributeNames.MOTION_INTENTS: InstrumentationAdapter.formatMotionIntentsRecord(_locomotionState.intents)
		}
	)
	
	_locomotionState.tracerAPI.END_SPAN(span_token)

func export(snapshot: Snapshot) -> void:
	snapshot.intents = _locomotionState.intents
	snapshot.bounded = _locomotionStyle.bounded

# Utils
func _update_state(payload: Payload) -> void:
	# Reset previous frames ephemeral state
	_locomotionState.intents.clear()
	
	# Intent-bearing Input
	_locomotionState.move_vector = payload.move_vector
	_locomotionState.is_focused = payload.is_focused
	_locomotionState.speedTier = payload.speedTier
	_locomotionState.worldState = payload.worldState
	_locomotionState.jump = payload.jump
	_locomotionState.dash = payload.dash
	_locomotionState.lift = payload.lift
	
	# Reference Basis
	_locomotionState.view_rotation_y = payload.view_rotation_y
	_locomotionState.view_direction_x = payload.view_direction_x
	_locomotionState.view_direction_z = payload.view_direction_z
	
	# Physical Actor State
	_locomotionState.motionState = payload.motionState
	
	# Set speed
	# 1. Determine range of speeds available based on World State
	_speed_vector = _getSpeedVector(_locomotionState.worldState)
	
	# 2. Dispatch speed based on Speed Tier
	_locomotionState.speed_multiplier = _speed_vector[_locomotionState.speedTier]

func _getStyle(style: Style) -> LocomotionStyle:
	match style:
		Style.BIPED:
			return BiPedal.new(_locomotionState)
		
		Style.OTS:
			return OverTheShoulder.new(_locomotionState)
		
		Style.TRAD:
			return TraditionalFree.new(_locomotionState)
	
	return BiPedal.new(_locomotionState)

func _getSpeedVector(worldState: WorldState) -> Array[float]:
	match worldState:
		WorldState.CASUAL:
			return _locomotionState.config.CASUAL_SPEED_VECTOR
	
		WorldState.ENGAGED:
			return _locomotionState.config.ENGAGED_SPEED_VECTOR
	
		WorldState.ALERT:
			return _locomotionState.config.ALERT_SPEED_VECTOR
		
		_:
			assert(false, "World State mismatch [LocomotionSemantics._getSpeedVector]")
	
	return _locomotionState.config.DEFAULT_SPEED_VECTOR

class Payload extends RefCounted:
	# Intent-bearing Input
	var move_vector: Vector2
	var is_focused: bool
	var speedTier: SpeedTier
	var worldState: WorldState
	var jump: bool
	var dash: bool
	var lift: bool
	
	# Reference Basis
	var view_rotation_y: float
	var view_direction_x: Vector3
	var view_direction_z: Vector3
	
	# Physical Actor State
	var motionState: MotionState

	func addIntentBearingInput(
		_move_vector: Vector2,
		_is_focused: bool,
		_speedTier: SpeedTier,
		_worldState: WorldState,
		_jump: bool,
		_dash: bool,
		_lift: bool
	) -> Payload:
		
		move_vector = _move_vector
		is_focused = _is_focused
		speedTier = _speedTier
		worldState = _worldState
		jump = _jump
		dash = _dash
		lift = _lift
		
		return self
	
	func addReferenceBasis(
		_view_rotation_y: float,
		_view_direction_x: Vector3,
		_view_direction_z: Vector3,
	) -> Payload:
		
		view_rotation_y = _view_rotation_y
		view_direction_x = _view_direction_x
		view_direction_z = _view_direction_z
		
		return self
	
	func addPhysicalActorState(
		_motionState: MotionState
	) -> Payload:
		
		motionState = _motionState
		
		return self

class Snapshot extends RefCounted:
	var intents: Array[MotionIntent]
	var bounded: bool
	
	func _init(locomotionSemantics: LocomotionSemantics) -> void:
		locomotionSemantics.export(self)
