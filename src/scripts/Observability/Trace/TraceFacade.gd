class_name TraceFacade
extends RefCounted

const TracerNames := {
	&"INTENT_REALIZATION_PIPELINE_CYCLE": &"Intent-Realization Pipeline cycle"
}

const SpanNames := {
	&"INTENT_REALIZATION_PIPELINE_RUN" : &"intentRealizationPipeline.run",
	&"INPUT_INTERFACE_EXECUTE"         : &"inputInterface.execute",
	&"VIEW_INTENT_MEDIATION_EXECUTE"   : &"viewIntentMediation.execute",
	&"INTENT_RESOLUTION_EXECUTE"       : &"intentResolution.execute",
	&"REALIZATION_AUTHORITY_EXECUTE"   : &"realizationAuthority.execute",
	&"PRESENTATION_MEDIATION_EXECUTE"  : &"presentationMediation.execute",
	&"AGENT_INPUT_HANDLER_EXECUTE"     : &"agentInputHandler.execute",
	&"VIEW_MANAGER_EXECUTE"            : &"viewManager.execute",
	&"VIEW_SEMANTICS_EXECUTE"          : &"viewSemantics.execute",
	&"LOCOMOTION_SEMANTICS_EXECUTE"    : &"locomotionSemantics.execute",
	&"MOTION_AUTHORITY_EXECUTE"        : &"motionAuthority.execute",
	&"ANIMATION_HANDLER_EXECUTE"       : &"animationHandler.execute"
}

const EventNames := {
	&"INTENT_RESOLVED"          : &"Intent Resolved",
	&"MOTION_INTENTS_AUTHORED"  : &"Motion Intents Authored",
	&"MOTION_PROPOSALS_CREATED" : &"Motion Proposals Created"
}

const AttributeNames := {
	&"LOOK_DELTA"       : &"look_delta",
	&"FOCUS"            : &"focus",
	&"SWAP_SHOULDER"    : &"swap_shoulder",
	&"MOVE_VECTOR"      : &"move_vector",
	&"SPEED_INTENT"     : &"speed_intent",
	&"JUMP"             : &"jump",
	&"DASH"             : &"dash",
	&"LIFT"             : &"lift",
	&"AMOUNT"           : &"Amount",
	&"MOTION_INTENTS"   : &"Motion Intents",
	&"MOTION_PROPOSALS" : &"Motion Proposals",
	&"HORIZONTAL"       : &"Horizontal",
	&"ROTATIONAL"       : &"Rotational",
	&"VERTICAL"         : &"Vertical",
	&"PRIORITY"         : &"priority",
	&"TEMPORALITY"      : &"temporality",
	&"APPLICATION"      : &"application",
	&"MAGNITUDE"        : &"magnitude",
	&"DIRECTION"        : &"direction",
	&"PLANAR_VECTOR"    : &"planar_vector",
	&"YAW"              : &"YAW"
}

var _config: TraceConfig
var _tracerAPIProvider := TracerAPIProvider.new()

func _init(config: TraceConfig) -> void:
	_config = config
	_setupTracerAPIs()

func getTracerAPI(name: StringName) -> TracerAPI:
	return _tracerAPIProvider.getTracerAPI(name)

# Utils
func _setupTracerAPIs() -> void:
	var intentRealizationPipelineCycleTracerAPI := TracerAPI.new(
		_config.INTENT_REALIZATION_PIPELINE_CYCLE_TRACER_CONFIG,
		SyncTracer.new(
			_config.INTENT_REALIZATION_PIPELINE_CYCLE_TRACER_CONFIG,
			_getSpanProcessor(
				_config.INTENT_REALIZATION_PIPELINE_CYCLE_TRACER_CONFIG.PROCESSOR,
				_getSpanExporter(_config.INTENT_REALIZATION_PIPELINE_CYCLE_TRACER_CONFIG.EXPORTER)
			)
		),
		_getSpanConfigMap(TracerNames.INTENT_REALIZATION_PIPELINE_CYCLE)
	)
	
	_tracerAPIProvider.registerTracerAPI(TracerNames.INTENT_REALIZATION_PIPELINE_CYCLE, intentRealizationPipelineCycleTracerAPI)

func _getSpanProcessor(processorType: ITracerConfig.ProcessorType, exporter: ISpanExporter) -> ISpanProcessor:
	match processorType:
		ITracerConfig.ProcessorType.SIMPLE:
			return SimpleSpanProcessor.new(exporter)
		
		ITracerConfig.ProcessorType.BATCH:
			return BatchSpanProcessor.new(exporter)
		
		_:
			assert(false, "ProcessorType mismatch [TraceFacade._getSpanProcessor]")
	
	return SimpleSpanProcessor.new(exporter)

func _getSpanExporter(exporterType: ITracerConfig.ExporterType) -> ISpanExporter:
	match exporterType:
		ITracerConfig.ExporterType.CONSOLE:
			return ConsoleSpanExporter.new()
		
		ITracerConfig.ExporterType.FILE:
			return FileSpanExporter.new()
		
		_:
			assert(false, "ExporterType mismatch [TraceFacade._getSpanExporter]")
	
	return ConsoleSpanExporter.new()

func _getSpanConfigMap(tracerName: StringName) -> Dictionary[StringName, ISpanConfig]:
	match tracerName:
		TracerNames.INTENT_REALIZATION_PIPELINE_CYCLE:
			return {
				SpanNames.INTENT_REALIZATION_PIPELINE_RUN : _config.INTENT_REALIZATION_PIPELINE_CYCLE_TRACER_CONFIG.INTENT_REALIZATION_PIPELINE_RUN,
				SpanNames.INPUT_INTERFACE_EXECUTE         : _config.INTENT_REALIZATION_PIPELINE_CYCLE_TRACER_CONFIG.INPUT_INTERFACE_EXECUTE,
				SpanNames.VIEW_INTENT_MEDIATION_EXECUTE   : _config.INTENT_REALIZATION_PIPELINE_CYCLE_TRACER_CONFIG.VIEW_INTENT_MEDIATION_EXECUTE,
				SpanNames.INTENT_RESOLUTION_EXECUTE       : _config.INTENT_REALIZATION_PIPELINE_CYCLE_TRACER_CONFIG.INTENT_RESOLUTION_EXECUTE,
				SpanNames.REALIZATION_AUTHORITY_EXECUTE   : _config.INTENT_REALIZATION_PIPELINE_CYCLE_TRACER_CONFIG.REALIZATION_AUTHORITY_EXECUTE,
				SpanNames.PRESENTATION_MEDIATION_EXECUTE  : _config.INTENT_REALIZATION_PIPELINE_CYCLE_TRACER_CONFIG.PRESENTATION_MEDIATION_EXECUTE,
				SpanNames.AGENT_INPUT_HANDLER_EXECUTE     : _config.INTENT_REALIZATION_PIPELINE_CYCLE_TRACER_CONFIG.AGENT_INPUT_HANDLER_EXECUTE,
				SpanNames.VIEW_MANAGER_EXECUTE            : _config.INTENT_REALIZATION_PIPELINE_CYCLE_TRACER_CONFIG.VIEW_MANAGER_EXECUTE,
				SpanNames.VIEW_SEMANTICS_EXECUTE          : _config.INTENT_REALIZATION_PIPELINE_CYCLE_TRACER_CONFIG.VIEW_SEMANTICS_EXECUTE,
				SpanNames.LOCOMOTION_SEMANTICS_EXECUTE    : _config.INTENT_REALIZATION_PIPELINE_CYCLE_TRACER_CONFIG.LOCOMOTION_SEMANTICS_EXECUTE,
				SpanNames.MOTION_AUTHORITY_EXECUTE        : _config.INTENT_REALIZATION_PIPELINE_CYCLE_TRACER_CONFIG.MOTION_AUTHORITY_EXECUTE,
				SpanNames.ANIMATION_HANDLER_EXECUTE       : _config.INTENT_REALIZATION_PIPELINE_CYCLE_TRACER_CONFIG.ANIMATION_HANDLER_EXECUTE
			}
		
		_:
			return {}
