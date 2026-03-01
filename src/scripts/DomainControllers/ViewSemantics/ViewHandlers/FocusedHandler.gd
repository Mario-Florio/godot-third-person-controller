class_name FocusedHandler
extends ViewHandler

func _handle_focus() -> void:
	_view.set_is_zoomed(true)

func _handle_swap_shoulder(payload: Payload) -> void:
	if _view is not FollowCameraMount: return
	
	if payload.swap_shoulder:
		_viewState.is_swapped = !_viewState.is_swapped
	
	_view.set_is_flipped(_viewState.is_swapped)

func _cleanup_swap_shoulder() -> void:
	pass