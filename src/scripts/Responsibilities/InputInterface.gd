class_name InputInterface
extends RefCounted

var _agentInputHandler: AgentInputHandler

func _init(agentInputHandler) -> void:
	_agentInputHandler = agentInputHandler

func execute() -> void:
	_agentInputHandler.execute()

func produce() -> IntentBearingInput:
	return IntentBearingInput.new(_agentInputHandler)

class IntentBearingInput extends RefCounted:
	# AgentInputHandler Snapshot
	var _look_delta: Vector2
	var _focus: bool
	var _swap_shoulder: bool
	
	func _init(agentInputHandler: AgentInputHandler) -> void:
		var agentIntent := AgentInputHandler.Snapshot.new(agentInputHandler)
		_look_delta = agentIntent.look_delta
		_focus = agentIntent.focus
		_swap_shoulder = agentIntent.swap_shoulder
	
	# Getters
	func look_delta() -> Vector2:
		return _look_delta
	
	func focus() -> bool:
		return _focus
	
	func swap_shoulder() -> bool:
		return _swap_shoulder
