class_name AgentInputHandler
extends RefCounted

enum SpeedIntent { SLOW, NORMAL, FAST }

# System Context
var _config: InputConfig
var _tracerAPI: TracerAPI

# Intentions
var _look_delta: Vector2         # Desired look change
var _look_delta_pending: Vector2 # Used to manage look_delta queue (storing mouse-motion captures each event | freeing stale state each frame)
var _focus: bool
var _swap_shoulder: bool
var _move_vector: Vector2        # Desired movement on ground plane
var _speed_intent: SpeedIntent
var _jump: bool
var _dash: bool
var _lift: bool

func _init(config: InputConfig, tracerAPI: TracerAPI) -> void:
	_config = config
	_tracerAPI = tracerAPI
	
	_init_input_map(_config.Actions.values())

func notify(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		_look_delta_pending += event.relative

func execute() -> void:
	var span_token := _tracerAPI.START_SPAN(Observability.SpanNames.AGENT_INPUT_HANDLER_EXECUTE)
	
	_reset_state()
	_resolve_intent()
	_tracerAPI.ADD_EVENT(span_token, Observability.EventNames.INTENT_RESOLVED, {
		&"look_delta": _look_delta,
		&"focus": _focus,
		&"swap_shoulder": _swap_shoulder,
		&"move_vector": _move_vector,
		&"speed_intent": _speed_intent,
		&"jump": _jump,
		&"dash": _dash,
		&"lift": _lift
	})
	
	_tracerAPI.END_SPAN(span_token)

func export(snapshot: Snapshot) -> void:
	snapshot.look_delta = _look_delta
	snapshot.focus = _focus
	snapshot.swap_shoulder = _swap_shoulder
	snapshot.move_vector = _move_vector
	snapshot.speed_intent = _speed_intent
	snapshot.jump = _jump
	snapshot.dash = _dash
	snapshot.lift = _lift

# Utils
func _reset_state() -> void: # Resets ephemeral state so stale intent isn't reused if not updated on resolve
	_look_delta = _look_delta_pending
	_look_delta_pending = Vector2.ZERO
	_swap_shoulder = false
	_jump = false
	_dash = false

func _resolve_intent() -> void:
	# Resolve focus intent
	if Input.is_action_pressed(_config.Actions.CAMERA_FOCUS): _focus = true
	else: _focus = false
	
	# Resolve shoulder switch intent
	if Input.is_action_just_pressed(_config.Actions.SWAP_SHOULDER): _swap_shoulder = true
	
	# Resolve move intent
	_move_vector = Input.get_vector(_config.Actions.LEFT, _config.Actions.RIGHT, _config.Actions.FORWARD, _config.Actions.BACKWARD)
	
	# Resolve speed intent
	if Input.is_action_pressed(_config.Actions.SPEED_UP):
		_speed_intent = SpeedIntent.FAST
	elif Input.is_action_pressed(_config.Actions.SLOW_DOWN):
		_speed_intent = SpeedIntent.SLOW
	else:
		_speed_intent = SpeedIntent.NORMAL
	
	# Resolve jump intent
	if Input.is_action_just_pressed(_config.Actions.JUMP): _jump = true
	
	# Resolve dash intent
	if Input.is_action_just_pressed(_config.Actions.DASH): _dash = true
	
	# Resolve lift intent
	if Input.is_action_pressed(_config.Actions.LIFT): _lift = true
	else: _lift = false

func _init_input_map(actions: Array) -> void:
	for action_name in actions:
		_ensure_action(action_name)
		
		match action_name:
			_config.Actions.CAMERA_FOCUS:
				var mouse_event := InputEventMouseButton.new()
				mouse_event.button_index = _config.camera_focus_mouse_button
				_map_event_to_action(action_name, mouse_event)
			
			_config.Actions.SWAP_SHOULDER:
				var key_event := InputEventKey.new()
				key_event.physical_keycode = _config.shoulder_swap_key
				_map_event_to_action(action_name, key_event)
			
			_config.Actions.FORWARD:
				var key_event := InputEventKey.new()
				key_event.physical_keycode = _config.forward_key
				_map_event_to_action(action_name, key_event)
	
			_config.Actions.BACKWARD:
				var key_event := InputEventKey.new()
				key_event.physical_keycode = _config.backward_key
				_map_event_to_action(action_name, key_event)
			
			_config.Actions.LEFT:
				var key_event := InputEventKey.new()
				key_event.physical_keycode = _config.left_key
				_map_event_to_action(action_name, key_event)
			
			_config.Actions.RIGHT:
				var key_event := InputEventKey.new()
				key_event.physical_keycode = _config.right_key
				_map_event_to_action(action_name, key_event)
			
			_config.Actions.SPEED_UP:
				var key_event := InputEventKey.new()
				key_event.physical_keycode = _config.speed_up_key
				_map_event_to_action(action_name, key_event)
			
			_config.Actions.SLOW_DOWN:
				var key_event := InputEventKey.new()
				key_event.physical_keycode = _config.slow_down_key
				_map_event_to_action(action_name, key_event)
			
			_config.Actions.JUMP:
				var key_event := InputEventKey.new()
				key_event.physical_keycode = _config.jump_key
				_map_event_to_action(action_name, key_event)
			
			_config.Actions.DASH:
				var mouse_event := InputEventMouseButton.new()
				mouse_event.button_index = _config.dash_mouse_button
				_map_event_to_action(action_name, mouse_event)
			
			_config.Actions.LIFT:
				var key_event := InputEventKey.new()
				key_event.physical_keycode = _config.lift_key
				_map_event_to_action(action_name, key_event)

func _ensure_action(action_name: String):
	if not InputMap.has_action(action_name):
		InputMap.add_action(action_name)

func _map_event_to_action(action_name: String, event: InputEvent) -> void:
	if not InputMap.has_action(action_name):
		InputMap.add_action(action_name)
	
	# Only add if event not already present
	for existing_event in InputMap.action_get_events(action_name):
		if existing_event == event:
			return
	InputMap.action_add_event(action_name, event)

class Snapshot extends RefCounted:
	var look_delta: Vector2
	var focus: bool
	var swap_shoulder: bool
	var move_vector: Vector2
	var speed_intent: SpeedIntent
	var jump: bool
	var dash: bool
	var lift: bool
	
	func _init(agentInputHandler: AgentInputHandler) -> void:
		agentInputHandler.export(self)
