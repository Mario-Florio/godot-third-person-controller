class_name ViewHandler
extends RefCounted

# Handles standard focus

# Using
const State   := ViewSemantics.State
const Payload := ViewSemantics.Payload

var _view: ViewInterface
var _viewState: State

func _init(view: ViewInterface, viewState: State):
	_view = view
	_viewState = viewState

func handle(payload: Payload) -> void:
	_handle_mouse_motion(payload.look_delta.x, payload.look_delta.y)
	_handle_focus()
	_handle_swap_shoulder(payload)
	_cleanup_swap_shoulder()

func _handle_mouse_motion(x: float, y: float) -> void:
	_view.adjust_yaw(-x)
	_view.adjust_pitch(-y)

func _handle_focus() -> void:
	_view.set_is_zoomed(false)

func _handle_swap_shoulder(_payload: Payload) -> void:
	pass

func _cleanup_swap_shoulder() -> void:
	if !_viewState.config.remember_swap:
		_viewState.is_swapped = false
		_view.set_is_flipped(false)

# Utils
func _swap_shoulder(payload: Payload) -> void:
	if payload.swap_shoulder:
		_viewState.is_swapped = !_viewState.is_swapped
	
	_view.set_is_flipped(_viewState.is_swapped)
