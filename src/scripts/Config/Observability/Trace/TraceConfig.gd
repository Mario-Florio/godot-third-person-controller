class_name TraceConfig
extends Resource

@export_group("Tracers")
@export var INTENT_REALIZATION_PIPELINE_CYCLE_TRACER_CONFIG: IntentRealizationPipelineCycleConfig

var _setup := false

func setup(
	intentRealizationPipelineCycleTracerConfig: IntentRealizationPipelineCycleConfig = null
) -> TraceConfig:
	if _setup == true: return
	
	_setup = true
	
	if intentRealizationPipelineCycleTracerConfig != null:
		INTENT_REALIZATION_PIPELINE_CYCLE_TRACER_CONFIG = intentRealizationPipelineCycleTracerConfig
	
	elif INTENT_REALIZATION_PIPELINE_CYCLE_TRACER_CONFIG == null:
		INTENT_REALIZATION_PIPELINE_CYCLE_TRACER_CONFIG = IntentRealizationPipelineCycleConfig.new()
	
	INTENT_REALIZATION_PIPELINE_CYCLE_TRACER_CONFIG.setup()
	
	return self
