class_name InputInterface
extends RefCounted

var _agentInputHandler: AgentInputHandler
var _viewProbe: ViewProbe

func _init(agentInputHandler) -> void:
	_agentInputHandler = agentInputHandler

func execute() -> void:
	_agentInputHandler.execute()

func produce() -> IntentBearingInput:
	return IntentBearingInput.new(_agentInputHandler)

func setViewProbe(viewProbe: ViewProbe) -> void:
	_viewProbe = viewProbe

class IntentBearingInput extends RefCounted:
	# AgentInputHandler Snapshot
	var _look_delta: Vector2
	var _focus: bool
	var _swap_shoulder: bool
	var _move_vector: Vector2
	var _speed_intent: StringName
	var _jump: bool
	var _dash: bool
	
	func _init(agentInputHandler: AgentInputHandler) -> void:
		var agentIntent := AgentInputHandler.Snapshot.new(agentInputHandler)
		_look_delta = agentIntent.look_delta
		_focus = agentIntent.focus
		_swap_shoulder = agentIntent.swap_shoulder
		_move_vector = agentIntent.move_vector
		_speed_intent = _convertSpeedIntent(agentIntent.speed_intent)
		_jump = agentIntent.jump
		_dash = agentIntent.dash
	
	# Getters
	func look_delta() -> Vector2:
		return _look_delta
	
	func focus() -> bool:
		return _focus
	
	func swap_shoulder() -> bool:
		return _swap_shoulder
	
	func move_vector() -> Vector2:
		return _move_vector
	
	func speed_intent() -> StringName:
		return _speed_intent
	
	func jump() -> bool:
		return _jump
	
	func dash() -> bool:
		return _dash
	
	# Utils
	func _convertSpeedIntent(val: AgentInputHandler.SpeedIntent) -> StringName:
		match val:
			
			AgentInputHandler.SpeedIntent.SLOW:
				return "SLOW"
			
			AgentInputHandler.SpeedIntent.NORMAL:
				return "NORMAL"
			
			AgentInputHandler.SpeedIntent.FAST:
				return "FAST"
		
		assert(
			false,
			"SpeedIntent mismatch [InputInterface.IntentBearingInput.convertSpeedIntent]"
		)
		
		return "NORMAL"
