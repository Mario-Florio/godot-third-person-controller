class_name LocomotionSemanticsExecuteSpanConfig
extends ISpanConfig

@export_group("Events")
@export var MOTION_INTENTS_AUTHORED: MotionIntentsAuthoredEventConfig

var _setup := false

func setup(motionIntentsAuthored: MotionIntentsAuthoredEventConfig = null) -> LocomotionSemanticsExecuteSpanConfig:
	if _setup == true: return
	
	_setup = true
	
	if motionIntentsAuthored != null: MOTION_INTENTS_AUTHORED = motionIntentsAuthored
	elif MOTION_INTENTS_AUTHORED == null: MOTION_INTENTS_AUTHORED = MotionIntentsAuthoredEventConfig.new()
	
	return self

func getEvents() -> Dictionary[StringName, IEventConfig]:
	return { TraceFacade.EventNames.MOTION_INTENTS_AUTHORED: MOTION_INTENTS_AUTHORED }
