class_name MotionProposalsCreatedEventConfig
extends IEventConfig

@export_group("Attributes")
@export var AMOUNT           := true
@export var MOTION_PROPOSALS := true
@export var HORIZONTAL       := true
@export var ROTATIONAL       := true
@export var VERTICAL         := true
@export var PRIORITY         := true
@export var APPLICATION      := true
@export var MAGNITUDE        := true
@export var PLANAR_VECTOR    := true
@export var YAW              := true

func getAttributes() -> Dictionary[StringName, bool]:
	return {
		TraceFacade.AttributeNames.AMOUNT           : AMOUNT,
		TraceFacade.AttributeNames.MOTION_PROPOSALS : MOTION_PROPOSALS,
		TraceFacade.AttributeNames.HORIZONTAL       : HORIZONTAL,
		TraceFacade.AttributeNames.ROTATIONAL       : ROTATIONAL,
		TraceFacade.AttributeNames.VERTICAL         : VERTICAL,
		TraceFacade.AttributeNames.PRIORITY         : PRIORITY,
		TraceFacade.AttributeNames.APPLICATION      : APPLICATION,
		TraceFacade.AttributeNames.MAGNITUDE        : MAGNITUDE,
		TraceFacade.AttributeNames.PLANAR_VECTOR    : PLANAR_VECTOR,
		TraceFacade.AttributeNames.YAW              : YAW
	}
