class_name ViewArbitrator
extends RefCounted

var _viewManagerState: ViewManager.State

var _last_views_size: int

func _init(viewManagerState: ViewManager.State) -> void:
	_viewManagerState = viewManagerState

func arbitrate() -> void:
	var views_arr_size := _viewManagerState.views.values().size()
	if views_arr_size != _last_views_size:
		_select_view()
	_last_views_size = views_arr_size

# Utils
func _select_view() -> void:
	if _viewManagerState.views.size() == 0: return
	
	var views_arr: Array = _viewManagerState.views.values()
	var curr: ViewInterface = views_arr[0]
	
	for viewInterface in views_arr:
		if viewInterface.viewArea.viewPriority < curr.viewArea.viewPriority:
			curr = viewInterface
	
	_viewManagerState.activeView = curr
