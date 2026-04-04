class_name IntentRealizationPipelineCycleConfig
extends ITracerConfig

@export_subgroup("Spans")
@export var INTENT_REALIZATION_PIPELINE_RUN : SpanConfig
@export var INPUT_INTERFACE_EXECUTE         : SpanConfig
@export var VIEW_INTENT_MEDIATION_EXECUTE   : SpanConfig
@export var INTENT_RESOLUTION_EXECUTE       : SpanConfig
@export var REALIZATION_AUTHORITY_EXECUTE   : RealizationAuthorityExecuteSpanConfig
@export var PRESENTATION_MEDIATION_EXECUTE  : SpanConfig
@export var AGENT_INPUT_HANDLER_EXECUTE     : AgentInputHandlerExecuteSpanConfig
@export var VIEW_MANAGER_EXECUTE            : SpanConfig
@export var VIEW_SEMANTICS_EXECUTE          : SpanConfig
@export var LOCOMOTION_SEMANTICS_EXECUTE    : LocomotionSemanticsExecuteSpanConfig
@export var MOTION_AUTHORITY_EXECUTE        : SpanConfig
@export var ANIMATION_HANDLER_EXECUTE       : SpanConfig

var _setup := false

func setup(
	intentRealizationPipelineRun : SpanConfig = null,
	inputInterfaceExecute        : SpanConfig = null,
	viewIntentMediationExecute   : SpanConfig = null,
	intentResolutionExecute      : SpanConfig = null,
	realizationAuthorityExecute  : RealizationAuthorityExecuteSpanConfig = null,
	presentationMediationExecute : SpanConfig = null,
	agentInputhandlerExecute     : AgentInputHandlerExecuteSpanConfig = null,
	viewManagerExecute           : SpanConfig = null,
	viewSemanticsExecute         : SpanConfig = null,
	locomotionSemanticsExecute   : LocomotionSemanticsExecuteSpanConfig = null,
	motionAuthorityExecute       : SpanConfig = null,
	animationHandlerExecute      : SpanConfig = null
) -> IntentRealizationPipelineCycleConfig:
	
	if _setup == true: return
	
	_setup = true
	
	if intentRealizationPipelineRun != null: INTENT_REALIZATION_PIPELINE_RUN = intentRealizationPipelineRun
	elif INTENT_REALIZATION_PIPELINE_RUN == null:
		INTENT_REALIZATION_PIPELINE_RUN = SpanConfig.new()
	
	if inputInterfaceExecute != null: INPUT_INTERFACE_EXECUTE = inputInterfaceExecute
	elif INPUT_INTERFACE_EXECUTE == null:
		INPUT_INTERFACE_EXECUTE = SpanConfig.new()
	
	if viewIntentMediationExecute != null: VIEW_INTENT_MEDIATION_EXECUTE = viewIntentMediationExecute
	elif VIEW_INTENT_MEDIATION_EXECUTE == null:
		VIEW_INTENT_MEDIATION_EXECUTE = SpanConfig.new()
	
	if intentResolutionExecute != null: INTENT_RESOLUTION_EXECUTE = intentResolutionExecute
	elif INTENT_RESOLUTION_EXECUTE == null:
		INTENT_RESOLUTION_EXECUTE = SpanConfig.new()
	
	if realizationAuthorityExecute != null: REALIZATION_AUTHORITY_EXECUTE = realizationAuthorityExecute
	elif REALIZATION_AUTHORITY_EXECUTE == null:
		REALIZATION_AUTHORITY_EXECUTE = RealizationAuthorityExecuteSpanConfig.new()
	
	if presentationMediationExecute != null: PRESENTATION_MEDIATION_EXECUTE = presentationMediationExecute
	elif PRESENTATION_MEDIATION_EXECUTE == null:
		PRESENTATION_MEDIATION_EXECUTE = SpanConfig.new()
	
	if agentInputhandlerExecute != null: AGENT_INPUT_HANDLER_EXECUTE = agentInputhandlerExecute
	elif AGENT_INPUT_HANDLER_EXECUTE == null:
		AGENT_INPUT_HANDLER_EXECUTE = AgentInputHandlerExecuteSpanConfig.new()
	
	if viewManagerExecute != null: VIEW_MANAGER_EXECUTE = viewManagerExecute
	elif VIEW_MANAGER_EXECUTE == null:
		VIEW_MANAGER_EXECUTE = SpanConfig.new()
	
	if viewSemanticsExecute != null: VIEW_SEMANTICS_EXECUTE = viewSemanticsExecute
	elif VIEW_SEMANTICS_EXECUTE == null:
		VIEW_SEMANTICS_EXECUTE = SpanConfig.new()
	
	if locomotionSemanticsExecute != null: LOCOMOTION_SEMANTICS_EXECUTE = locomotionSemanticsExecute
	elif LOCOMOTION_SEMANTICS_EXECUTE == null:
		LOCOMOTION_SEMANTICS_EXECUTE = LocomotionSemanticsExecuteSpanConfig.new()
	
	if motionAuthorityExecute != null: MOTION_AUTHORITY_EXECUTE = motionAuthorityExecute
	elif MOTION_AUTHORITY_EXECUTE == null:
		MOTION_AUTHORITY_EXECUTE = SpanConfig.new()
	
	if animationHandlerExecute != null: ANIMATION_HANDLER_EXECUTE = animationHandlerExecute
	elif ANIMATION_HANDLER_EXECUTE == null:
		ANIMATION_HANDLER_EXECUTE = SpanConfig.new()
	
	return self
