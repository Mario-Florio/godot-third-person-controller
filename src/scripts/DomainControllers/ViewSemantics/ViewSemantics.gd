class_name ViewSemantics
extends RefCounted

class State extends RefCounted:
	var config: ViewConfig
	
	var is_focused := false
	var is_swapped := false
	
	func _init(_config: ViewConfig) -> void:
		config = _config

var _view: ViewInterface
var _viewUpdated := false
var _viewState: State
var _viewHandlers: Dictionary
var _viewHandler: ViewHandler

func _init(config: ViewConfig) -> void:
	_viewState = State.new(config)
	_viewHandlers.standard = ViewHandler.new(_view, _viewState)
	_viewHandlers.focused = FocusedHandler.new(_view, _viewState)
	_viewHandler = _viewHandlers.standard

func execute(payload: Payload) -> void:
	if _viewUpdated == true:
		_updateView(payload.activeView)
	
	if _view == null: return # Guard against cases where no view is active
	
	_update_state(payload)
	_viewHandler.handle(payload)

func export() -> void:
	pass

func on_view_updated() -> void:
	_viewUpdated = true

# Utils
func _updateView(view: ViewInterface) -> void:
	if _view and _view.id == view.id: return
	if _view: _view.deactivate()
	_view = view
	_view.activate()
	_viewHandlers.standard._view = _view
	_viewHandlers.focused._view = _view
	_viewUpdated = false

func _update_state(payload: Payload) -> void:
	if payload.focus:
		_viewState.is_focused = true
		_viewHandler = _viewHandlers.focused
	else:
		_viewState.is_focused = false
		_viewHandler = _viewHandlers.standard

class Payload extends RefCounted:
	var look_delta: Vector2
	var focus: bool
	var swap_shoulder: bool
	var activeView: ViewInterface
	
	func _init(
		_look_delta: Vector2,
		_focus: bool,
		_swap_shoulder: bool
	) -> void:
		
		look_delta = _look_delta
		focus = _focus
		swap_shoulder = _swap_shoulder
	
	func addActiveView(_activeView: ViewInterface) -> Payload:
		activeView = _activeView
		return self
