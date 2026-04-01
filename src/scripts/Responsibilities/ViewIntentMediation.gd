class_name ViewIntentMediation
extends RefCounted

# Domain Controllers
var _viewManager: ViewManager
var _viewSemantics: ViewSemantics

# System Context
var _tracerAPI: TracerAPI

func _init(viewManager: ViewManager, viewSemantics: ViewSemantics, tracerAPI: TracerAPI) -> void:
	_viewManager = viewManager
	_viewSemantics = viewSemantics
	_tracerAPI = tracerAPI

func execute(intentBearingInput: InputInterface.IntentBearingInput) -> void:
	var span_token := _tracerAPI.START_SPAN(Observability.SpanNames.VIEW_INTENT_MEDIATION_EXECUTE)
	
	_viewManager.execute()
	
	var canonicalView := ViewManager.Snapshot.new(_viewManager)
	
	_viewSemantics.execute(ViewSemantics.Payload.new(
		intentBearingInput.look_delta(),
		intentBearingInput.focus(),
		intentBearingInput.swap_shoulder()
	).addActiveView(canonicalView.activeView))
	
	_tracerAPI.END_SPAN(span_token)

func produce() -> ReferenceBasis:
	return ReferenceBasis.new(_viewManager)

class ReferenceBasis extends RefCounted:
	var _global_transform: Transform3D
	
	func _init(viewManager: ViewManager) -> void:
		var canonicalView := ViewManager.Snapshot.new(viewManager)
		if canonicalView.activeView:
			_global_transform = canonicalView.activeView.global_transform
	
	# Getters
	func global_transform() -> Transform3D:
		return _global_transform
