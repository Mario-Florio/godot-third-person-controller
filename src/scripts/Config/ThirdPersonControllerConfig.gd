class_name ThirdPersonControllerConfig
extends Resource

@export var INPUT_CONFIG         : InputConfig
@export var VIEW_CONFIG          : ViewConfig
@export var LOCOMOTION_CONFIG    : LocomotionConfig
@export var MOTION_CONFIG        : MotionConfig
@export var ANIMATION_CONFIG     : AnimationConfig
@export var POSITION_CONFIG      : PositionConfig
@export var OBSERVABILITY_CONFIG : ObservabilityConfig

var _setup := false

func setup(
	inputConfig: InputConfig = null,
	viewConfig: ViewConfig = null,
	locomotionConfig: LocomotionConfig = null,
	motionConfig: MotionConfig = null,
	animationConfig: AnimationConfig = null,
	positionConfig: PositionConfig = null,
	observabilityConfig: ObservabilityConfig = null
) -> ThirdPersonControllerConfig:
	
	if _setup == true: return
	
	_setup = true
	
	if inputConfig != null: INPUT_CONFIG = inputConfig
	elif INPUT_CONFIG == null: INPUT_CONFIG = InputConfig.new()
	
	if viewConfig != null: VIEW_CONFIG = viewConfig
	elif VIEW_CONFIG == null: VIEW_CONFIG = ViewConfig.new()
	
	if locomotionConfig != null: LOCOMOTION_CONFIG = locomotionConfig
	elif LOCOMOTION_CONFIG == null: LOCOMOTION_CONFIG = LocomotionConfig.new()
	
	if motionConfig != null: MOTION_CONFIG = motionConfig
	elif MOTION_CONFIG == null: MOTION_CONFIG = MotionConfig.new()
	
	if observabilityConfig != null: OBSERVABILITY_CONFIG = observabilityConfig
	elif OBSERVABILITY_CONFIG == null: OBSERVABILITY_CONFIG = ObservabilityConfig.new()
	
	OBSERVABILITY_CONFIG.setup()
	
	# Optional
	if animationConfig != null: ANIMATION_CONFIG = animationConfig
	if positionConfig != null: POSITION_CONFIG = positionConfig
	
	return self

func setAnimationConfig(animationConfig: AnimationConfig) -> void:
	ANIMATION_CONFIG = animationConfig

func setPositionConfig(positionConfig: PositionConfig) -> void:
	POSITION_CONFIG = positionConfig
