class_name ViewManager
extends RefCounted

var _activeView: ViewInterface

func execute() -> void:
	pass

func export(snapshot: Snapshot) -> void:
	if _activeView:
		snapshot.activeView = _activeView

func setInitialView(view: ViewInterface) -> void:
	_activeView = view
	active_view_updated.emit()

signal active_view_updated()

class Snapshot extends RefCounted:
	var activeView: ViewInterface
	
	func _init(viewManager: ViewManager) -> void:
		viewManager.export(self)
