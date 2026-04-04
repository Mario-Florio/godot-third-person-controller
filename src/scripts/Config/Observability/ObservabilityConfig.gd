class_name ObservabilityConfig
extends Resource

@export var TRACE_CONFIG: TraceConfig

var _setup := false

func setup(traceConfig: TraceConfig = null) -> ObservabilityConfig:
	if _setup == true: return
	
	_setup = true
	
	if traceConfig != null: TRACE_CONFIG = traceConfig
	elif TRACE_CONFIG == null: TRACE_CONFIG = TraceConfig.new()
	
	TRACE_CONFIG.setup()
	
	return self
