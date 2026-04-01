class_name IntentResolvedEventConfig
extends IEventConfig

@export_group("Attributes")
@export var LOOK_DELTA    := true
@export var FOCUS         := true
@export var SWAP_SHOULDER := true
@export var MOVE_VECTOR   := true
@export var SPEED_INTENT  := true
@export var JUMP          := true
@export var DASH          := true
@export var LIFT          := true

func getAttributes() -> Dictionary[StringName, bool]:
	return {
		TraceFacade.AttributeNames.LOOK_DELTA    : LOOK_DELTA,
		TraceFacade.AttributeNames.FOCUS         : FOCUS,
		TraceFacade.AttributeNames.SWAP_SHOULDER : SWAP_SHOULDER,
		TraceFacade.AttributeNames.MOVE_VECTOR   : MOVE_VECTOR,
		TraceFacade.AttributeNames.SPEED_INTENT  : SPEED_INTENT,
		TraceFacade.AttributeNames.JUMP          : JUMP,
		TraceFacade.AttributeNames.DASH          : DASH,
		TraceFacade.AttributeNames.LIFT          : LIFT
	}
