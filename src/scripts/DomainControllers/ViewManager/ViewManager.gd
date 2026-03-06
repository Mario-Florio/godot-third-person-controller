class_name ViewManager
extends RefCounted

class State extends RefCounted:
	var _viewManager: ViewManager
	
	var activeView: ViewInterface:
		set(value):
			if value == activeView: return
			
			activeView = value
			_viewManager.active_view_updated.emit()
	
	var views: Dictionary # ViewInterface.id : ViewInterface
	
	func _init(viewManager: ViewManager) -> void:
		_viewManager = viewManager

var _viewManagerState: State
var _viewRegistry: ViewRegistry
var _viewArbitrator: ViewArbitrator

func _init() -> void:
	_viewManagerState = State.new(self)
	_viewRegistry = ViewRegistry.new(_viewManagerState)
	_viewArbitrator = ViewArbitrator.new(_viewManagerState)

func execute() -> void:
	_viewRegistry.register()
	_viewArbitrator.arbitrate()

func export(snapshot: Snapshot) -> void:
	if _viewManagerState.activeView:
		snapshot.activeView = _viewManagerState.activeView

func setInitialView(view: ViewInterface) -> void:
	_viewManagerState.activeView = view

@warning_ignore("unused_signal") # Signal is used in domains state container
signal active_view_updated()

func view_discovered(viewArea: ViewArea) -> void:
	_viewRegistry.view_discovered(viewArea)

func view_lost(viewArea: ViewArea) -> void:
	_viewRegistry.view_lost(viewArea)

class Snapshot extends RefCounted:
	var activeView: ViewInterface
	
	func _init(viewManager: ViewManager) -> void:
		viewManager.export(self)
