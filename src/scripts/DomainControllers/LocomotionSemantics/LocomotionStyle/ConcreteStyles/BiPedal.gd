class_name BiPedal
extends LocomotionStyle

func author() -> Array[MotionIntent]:
	var _authoredIntents: Array[MotionIntent] = []
	_is_bounded()
	
	if bounded or _move_dir_changed():
		_authoredIntents.append(_author_face_forward())
	
	_authoredIntents.append(_author_move())
	
	if _locomotionState.jump and _JUMP_ENABLED():
		_authoredIntents.append(_author_jump())
	
	if _locomotionState.dash and _DASH_ENABLED():
		_authoredIntents.append(_author_dash())
	
	return _authoredIntents

# Utils
func _author_face_forward() -> RotationalIntent:
	var speed_multiplier := 1.0
	var forward_dir: float
	if bounded:
		forward_dir = _locomotionState.view_rotation_y
	else:
		var move_dir := _get_move_direction()
		forward_dir = atan2(-move_dir.x, -move_dir.z)
	
	return FACE_FORWARD.express(speed_multiplier, forward_dir)

func _author_move() -> HorizontalIntent:
	var move_dir := _get_move_direction()
	
	return MOVE.express(
		_locomotionState.speed_multiplier,
		Vector2(move_dir.x, move_dir.z)
	)

func _author_jump() -> VerticalIntent:
	var accel_multiplier := 1.0
	return JUMP.express(accel_multiplier)

func _author_dash() -> HorizontalIntent:
	var accel_multiplier := 1.0
	var move_dir := _get_move_direction()
	
	return DASH.express(
		accel_multiplier,
		Vector2(move_dir.x, move_dir.z)
	)

func _is_bounded() -> void:
	match _locomotionState.motionState:
		MotionState.STILL:
			bounded = _WHILE_STILL()
		
		MotionState.GROUNDED:
			bounded = _WHILE_MOVING()
		
		MotionState.AIRBORNE:
			bounded = _WHILE_AIRBORNE()
		
		_:
			assert(false, "MotionState mismatch [BiPedal._is_bounded]")
	
	if _locomotionState.is_focused:
		bounded = _WHILE_AIMING()

## Used to determine if forward facing direction needs to be updated.
func _move_dir_changed() -> bool:
	# Since forward facing direction is primarly driven by move_dir (when unbounded),
	# an unchanged move_dir reflects z=0, changing facing direction even if not intended.
	if _get_move_direction() == Vector3.ZERO:
		return false
	else:
		return true
