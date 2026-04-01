class_name MotionIntentsAuthoredEventConfig
extends IEventConfig

@export_group("Attributes")
@export var AMOUNT         := true
@export var MOTION_INTENTS := true
@export var HORIZONTAL     := true
@export var ROTATIONAL     := true
@export var VERTICAL       := true
@export var PRIORITY       := true
@export var TEMPORALITY    := true
@export var MAGNITUDE      := true
@export var DIRECTION      := true
@export var YAW            := true

func getAttributes() -> Dictionary[StringName, bool]:
	return {
		TraceFacade.AttributeNames.AMOUNT         : AMOUNT,
		TraceFacade.AttributeNames.MOTION_INTENTS : MOTION_INTENTS,
		TraceFacade.AttributeNames.HORIZONTAL     : HORIZONTAL,
		TraceFacade.AttributeNames.ROTATIONAL     : ROTATIONAL,
		TraceFacade.AttributeNames.VERTICAL       : VERTICAL,
		TraceFacade.AttributeNames.PRIORITY       : PRIORITY,
		TraceFacade.AttributeNames.TEMPORALITY    : TEMPORALITY,
		TraceFacade.AttributeNames.MAGNITUDE      : MAGNITUDE,
		TraceFacade.AttributeNames.DIRECTION      : DIRECTION,
		TraceFacade.AttributeNames.YAW            : YAW
	}
