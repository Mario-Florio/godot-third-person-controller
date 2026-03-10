class_name FollowCameraMount
extends CameraMount

@export var follow_target: Node3D
@export var spring_arm: SpringArm3D
@export var anchor_point := 1.5

var _curr_spring_length: float = config.DEFAULT_SPRING_ARM_LENGTH
var _curr_spring_arm_position_x: float = config.DEFAULT_SPRING_ARM_POSITION_X
var _is_zoomed : bool = false
var _is_flipped: bool = false

func _ready() -> void:
	super()
	spring_arm.position.x = config.DEFAULT_SPRING_ARM_POSITION_X
	spring_arm.position.y = config.DEFAULT_SPRING_ARM_POSITION_Y

func _physics_process(delta: float) -> void:
	super(delta)
	if !follow_target: return
	
	if _is_zoomed:
		_curr_spring_length = config.FOCUSED_SPRING_ARM_LENGTH
	else:
		_curr_spring_length = config.DEFAULT_SPRING_ARM_LENGTH
	
	if _is_flipped:
		_curr_spring_arm_position_x = -config.DEFAULT_SPRING_ARM_POSITION_X
	else:
		_curr_spring_arm_position_x = config.DEFAULT_SPRING_ARM_POSITION_X
	
	var target_position := follow_target.global_transform.origin
	target_position.y += anchor_point
	
	_anchor_to_target(target_position)
	_adjust_spring_length(_curr_spring_length)
	_adjust_spring_arm_position_x(_curr_spring_arm_position_x)

# Methods
func set_is_zoomed(is_zoomed: bool) -> void:
	_is_zoomed = is_zoomed

func set_is_flipped(is_flipped) -> void:
	_is_flipped = is_flipped

# Utils
func _anchor_to_target(target_position) -> void:
	global_position = lerp(global_position, target_position, config.FOLLOW_RATE)

func _adjust_spring_length(length: float) -> void:
	spring_arm.spring_length = lerp(spring_arm.spring_length, length, 0.2)

func _adjust_spring_arm_position_x(position_x: float) -> void:
	if spring_arm.position.x != position_x:
		spring_arm.position.x = lerp(spring_arm.position.x, position_x, 0.2)
