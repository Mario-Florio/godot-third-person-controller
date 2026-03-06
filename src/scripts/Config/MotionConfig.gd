class_name MotionConfig
extends Resource

# Designer Dials
@export_range(0.0, 1.0) var horizontal_responsiveness := 0.70:
	set(value): horizontal_responsiveness = clamp(value, 0.1, 1.0)

@export_range(0.0, 1.0) var rotational_responsiveness := 0.70:
	set(value): rotational_responsiveness = clamp(value, 0.1, 1.0)

## Effects vertical continuous motion.
@export_range(0.0, 1.0) var vertical_responsiveness := 0.70:
	set(value): vertical_responsiveness = clamp(value, 0.1, 1.0)

# Advanced Dials
@export_group("Advanced Dials")
## Used alongside Turn Ratio to govern Horizontal Responsiveness.
## Adjusts how fast horizontal accelaration is applied in intended direction.
@export_range(0.0, 60.0) var MAX_HORIZONTAL_ACCEL_RATE := 20.0

## Used alonside Max Horizontal Accel Rate to govern Horizontal Responsiveness.
## Adjusts how fast horizontal direction change aligns with forward intent.
## Feel:
## < 1.00 = drunk ;
## ~ 1.25 = loose ;
## ~ 1.50 = grounded ;
## ~ 2.00 = crisp ;
## ~ 3.00 = arcade ;
@export_range(0.0, 3.0) var TURN_RATIO := 1.50

# Constants
@export_group("Constants")
@export var MAX_HORIZONTAL_SPEED             := 4.50
@export var MAX_VERTICAL_IMPULSE_VELOCITY    := 3.50
@export var MAX_HORIZONTAL_IMPULSE_VELOCITY  := 7.00
@export var MAX_VERTICAL_CONTINUOUS_VELOCITY := 1.75

# Rules
@export_group("Rules")
@export var HORIZONTAL_AIRBORNE_INTENT_ALLOWED := false
@export var ROTATIONAL_AIRBORNE_INTENT_ALLOWED := false
@export var VERTICAL_AIRBORNE_IMPULSE_ALLOWED  := false
