class_name ViewRegistry
extends RefCounted

enum PendingState { DISCOVERED, LOST }

var _pendingViews: Array[PendingView] = []
var _viewManagerState: ViewManager.State

func _init(viewManagerState: ViewManager.State) -> void:
	_viewManagerState = viewManagerState

func register() -> void:
	if _pendingViews.size() > 0:
		_resolve()

# Utils
func _resolve() -> void:
	for pendingView in _pendingViews:
		if pendingView.pendingState == PendingState.DISCOVERED:
			_viewManagerState.views[pendingView.viewInterface.id] = pendingView.viewInterface
		
		if pendingView.pendingState == PendingState.LOST:
			_viewManagerState.views.erase(pendingView.viewInterface.id)
	
	_pendingViews.clear()

func view_discovered(viewArea: ViewArea) -> void:
	_pendingViews.append(PendingView.new(viewArea.viewInterface, PendingState.DISCOVERED))

func view_lost(viewArea: ViewArea) -> void:
	_pendingViews.append(PendingView.new(viewArea.viewInterface, PendingState.LOST))

class PendingView extends RefCounted:
	var viewInterface: ViewInterface
	var pendingState: PendingState
	
	func _init(_viewInterface: ViewInterface, _pendingState: PendingState) -> void:
		viewInterface = _viewInterface
		pendingState = _pendingState
