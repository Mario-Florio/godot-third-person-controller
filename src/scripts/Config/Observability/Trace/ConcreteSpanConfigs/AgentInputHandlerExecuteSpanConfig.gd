class_name AgentInputHandlerExecuteSpanConfig
extends ISpanConfig

@export_group("Events")
@export var INTENT_RESOLVED: IntentResolvedEventConfig

var _setup := false

func setup(intentResolved: IntentResolvedEventConfig = null) -> AgentInputHandlerExecuteSpanConfig:
	if _setup == true: return
	
	_setup = true
	
	if intentResolved != null: INTENT_RESOLVED = intentResolved
	elif INTENT_RESOLVED == null: INTENT_RESOLVED = IntentResolvedEventConfig.new()
	
	return self

func getEvents() -> Dictionary[StringName, IEventConfig]:
	return { TraceFacade.EventNames.INTENT_RESOLVED: INTENT_RESOLVED }
