class_name ViewIntentMediation
extends RefCounted

var _viewManager: ViewManager
var _viewSemantics: ViewSemantics

func _init(viewManager: ViewManager, viewSemantics: ViewSemantics) -> void:
	_viewManager = viewManager
	_viewSemantics = viewSemantics

func execute(intentBearingInput: InputInterface.IntentBearingInput) -> void:
	_viewManager.execute()
	
	var canonicalView := ViewManager.Snapshot.new(_viewManager)
	
	_viewSemantics.execute(ViewSemantics.Payload.new(
		intentBearingInput.look_delta(),
		intentBearingInput.focus(),
		intentBearingInput.swap_shoulder()
	).addActiveView(canonicalView.activeView))

func produce() -> ReferenceBasis:
	return ReferenceBasis.new(_viewManager)

class ReferenceBasis extends RefCounted:
	var _global_transform: Transform3D
	
	func _init(viewManager: ViewManager) -> void:
		var canonicalView := ViewManager.Snapshot.new(viewManager)
		_global_transform = canonicalView.activeView.global_transform
	
	# Getters
	func global_transform() -> Transform3D:
		return _global_transform
