class_name ViewProbe
extends RefCounted

var _viewArea: ViewArea

func _init(viewArea: ViewArea) -> void:
	_viewArea = viewArea
	_viewArea.connect("area_entered", _on_area_entered)
	_viewArea.connect("area_exited", _on_area_exited)

func execute() -> void:
	pass

func export() -> void:
	pass

signal view_discovered(viewArea: ViewArea)
signal view_lost(viewArea: ViewArea)

func connectHandler(signalName: StringName, handler: Callable) -> void:
	if !has_signal(signalName):
		assert(false, "Signal doesn't exist [ViewProbe.connectHandler]")
	
	connect(signalName, handler)

func setViewArea(viewArea: ViewArea) -> void:
	_viewArea = viewArea

# Utils
func _on_area_entered(area: Area3D) -> void:
	if area.is_in_group("Views") and area is ViewArea:
		view_discovered.emit(area)

func _on_area_exited(area: Area3D) -> void:
	if area.is_in_group("Views") and area is ViewArea:
		view_lost.emit(area)
