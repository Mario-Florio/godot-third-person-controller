class_name TracerAPIProvider
extends RefCounted

var _tracerAPIs: Dictionary[StringName, TracerAPI] = {}

func registerTracerAPI(name: StringName, tracerAPI :TracerAPI) -> void:
	assert(_tracerAPIs.has(name) == false, "TracerAPI " + name + " is already registered [TracerAPI.registerTracerAPI]")
	_tracerAPIs.set(name, tracerAPI)

func getTracerAPI(name: StringName) -> TracerAPI:
	assert(_tracerAPIs.has(name), "TracerAPI " + name +  " is not registered [TracerAPIProvider.getTracerAPI]")
	return _tracerAPIs.get(name)
