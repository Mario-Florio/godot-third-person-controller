class_name Observability
extends RefCounted

# Using
const TracerNames    := TraceFacade.TracerNames
const SpanNames      := TraceFacade.SpanNames
const EventNames     := TraceFacade.EventNames
const AttributeNames := TraceFacade.AttributeNames

var _config: ObservabilityConfig

var _traceFacade: TraceFacade

func _init(config: ObservabilityConfig) -> void:
	_config = config
	_traceFacade = TraceFacade.new(_config.TRACE_CONFIG)

func getTracerAPI(name: StringName) -> TracerAPI:
	return _traceFacade.getTracerAPI(name)
