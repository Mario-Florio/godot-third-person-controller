@tool
class_name LocomotionConfig
extends Resource

## Locomotion style. Determines semantic action expression.
@export var STYLE := LocomotionSemantics.Style.TRAD: # BIPED (experimental) | OTS | TRAD
	set(value):
		STYLE = value
		_apply_style_constraints()
		notify_property_list_changed()

@export_group("Bounded")
# Bounded States (used to bound locomotion to camera)
@export var WHILE_STILL       := false
@export var WHILE_MOVING      := false
@export var WHILE_AIRBORNE    := false
@export var WHILE_AIMING      := true

@export_group("Semantic Actions")
# Semantic Action Toggles (used to enable SemanticAction; see SemanticAction.gd for implementation)
@export var JUMP_ENABLED := true
@export var DASH_ENABLED := true

@export_group("Speed Multipliers")
# SPEED MULTIPLIERS (values representing percentages of MAX_HORIZONTAL_SPEED see Motion Domain below)

## Walk speed as a percentage of Max Horizontal Speed.
@export_range(0.0, 1.0) var WALK_SPEED_MULTIPLIER   := 0.40

## Jog speed as a percentage of Max Horizontal Speed.
@export_range(0.0, 1.0) var JOG_SPEED_MULTIPLIER    := 0.75

## Run speed as a percentage of Max Horizontal Speed.
@export_range(0.0, 1.0) var RUN_SPEED_MULTIPLIER    := 0.90

## Sprint speed as a percentage of Max Horizontal Speed.
@export_range(0.0, 1.0) var SPRINT_SPEED_MULTIPLIER := 1.00

@export_group("Speed Vectors")
# Speed Vectors correspond to curr_world_state within current implementation (i.e., CASUAL, ENGAGED, ALERT).
# Speed Tiers correspond to input Intent (i.e., SLOW_DOWN, SPEED_UP, RED_LINE; NORMAL speed-tier corresponds to no action modifier).
# Dispatch of speed vectors can be determined by other factors outside of world state if desired,
# or not at all (see LocomotionController._update_state() for implementation).

var WALK   := WALK_SPEED_MULTIPLIER
var JOG    := JOG_SPEED_MULTIPLIER
var RUN    := RUN_SPEED_MULTIPLIER
var SPRINT := SPRINT_SPEED_MULTIPLIER

# SPEED TIER             :                  SLOW | NORMAL | FAST   | FASTEST      
var CASUAL_SPEED_VECTOR  : Array[float] = [ WALK , WALK   , JOG    , SPRINT ]
var ENGAGED_SPEED_VECTOR : Array[float] = [ WALK , JOG    , RUN    , SPRINT ]
var ALERT_SPEED_VECTOR   : Array[float] = [ WALK , RUN    , SPRINT , SPRINT ]
var DEFAULT_SPEED_VECTOR : Array[float] = ENGAGED_SPEED_VECTOR

# Utils
func _validate_property(property: Dictionary) -> void:
	if property.name == "WHILE_MOVING":
		if (STYLE == LocomotionSemantics.Style.TRAD or
			STYLE == LocomotionSemantics.Style.OTS):
			
			property.usage = PROPERTY_USAGE_READ_ONLY

func _apply_style_constraints() -> void:
	match STYLE:
		LocomotionSemantics.Style.TRAD:
			WHILE_MOVING = false
		
		LocomotionSemantics.Style.OTS:
			WHILE_MOVING = true
