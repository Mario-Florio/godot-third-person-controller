class_name MotionResolver
extends RefCounted

# Using
const ForceApplication := MotionAuthority.ForceApplication
const MotionState      := MotionAuthority.MotionState

var _motionState: MotionAuthority.State

func _init(motionState: MotionAuthority.State) -> void:
	_motionState = motionState

func resolve(delta: float) -> void:
	_resolve_horizontal(delta)
	_resolve_rotational()
	_resolve_vertical(delta)

# Utils
func _accel_rate() -> float:
	var HOR_RES_DIAL := pow(_motionState.config.horizontal_responsiveness, 2.0)
	return HOR_RES_DIAL * _motionState.config.MAX_HORIZONTAL_ACCEL_RATE

func _turn_brake() -> float:
	return _accel_rate() * _motionState.config.TURN_RATIO

func _rotational_weight() -> float:
	return pow(_motionState.config.rotational_responsiveness, 2.0)

func _resolve_horizontal(delta: float) -> void:
	var horizontalProposal: MotionProposal.Horizontal = _motionState.horizontalProposal
	if horizontalProposal == null: return
	
	match horizontalProposal.application:
		ForceApplication.IMPULSE:
			_horizontal_impulse(horizontalProposal.magnitude, horizontalProposal.planar_vector)
		
		ForceApplication.CONTINUOUS:
			_horizontal_continuous(delta, horizontalProposal.magnitude, horizontalProposal.planar_vector)
		
		_:
			assert(false, "Horizontal Proposal mismatch [MotionResolver._resolve_horizontal]")

func _resolve_rotational() -> void:
	var rotationalProposal = _motionState.rotationalProposal
	if rotationalProposal == null: return
	
	match rotationalProposal.application:
		ForceApplication.IMPULSE:
			_rotational_impulse(rotationalProposal.yaw)
		
		ForceApplication.CONTINUOUS:
			pass
		
		_:
			assert(false, "Rotational Proposal mismatch [MotionResolver._resolve_rotational]")

func _resolve_vertical(delta) -> void:
	var verticalProposal: MotionProposal.Vertical = _motionState.verticalProposal
	if verticalProposal == null: return
	
	match verticalProposal.application:
		ForceApplication.IMPULSE:
			_vertical_impulse(verticalProposal.magnitude)
			
		ForceApplication.CONTINUOUS:
			_vertical_continuous(delta, verticalProposal.magnitude)
		_:
			assert(false, "Vertical Proposal mismatch [MotionResolver._resolve_vertical]")

func _horizontal_continuous(delta: float, magnitude: float, planar_vector: Vector2) -> void:
	# Apply CONTINUOUS force to horizontal velocity at turn rate
	var motionTarget := _motionState.motionTarget
	
	var desired_velocity: Vector2 = planar_vector * (magnitude * _motionState.config.MAX_HORIZONTAL_SPEED)
	var current_velocity := Vector2(motionTarget.velocity.x, motionTarget.velocity.z)
	var parallel: Vector2
	var lateral: Vector2
	
	if desired_velocity.length() > 0.0:
		var forward_momentum := desired_velocity.normalized()
		parallel = current_velocity.project(forward_momentum)
		lateral = current_velocity - parallel
	
	else:
		parallel = Vector2.ZERO
		lateral = current_velocity
	
	parallel = parallel.lerp(desired_velocity, _accel_rate() * delta)
	lateral = lateral.move_toward(Vector2.ZERO, _turn_brake() * delta)
	
	motionTarget.velocity.x = parallel.x + lateral.x
	motionTarget.velocity.z = parallel.y + lateral.y

func _horizontal_impulse(magnitude: float, planar_vector: Vector2) -> void:
	var motionTarget := _motionState.motionTarget
	
	motionTarget.velocity.x += (planar_vector.x *
		(magnitude * _motionState.config.MAX_HORIZONTAL_IMPULSE_VELOCITY))
	
	motionTarget.velocity.z += (planar_vector.y *
		(magnitude * _motionState.config.MAX_HORIZONTAL_IMPULSE_VELOCITY))

func _rotational_impulse(yaw: float) -> void:
	var current_yaw = _motionState.motionTarget.rotation.y
	var target_yaw  = yaw

	# shortest-arc delta
	var delta = wrapf(target_yaw - current_yaw, -PI, PI)

	# apply responsiveness
	current_yaw += delta * _rotational_weight()

	_motionState.motionTarget.rotation.y = current_yaw

func _vertical_continuous(delta: float, magnitude: float) -> void:
	var motionTarget := _motionState.motionTarget
	
	var target_vertical_velocity := _motionState.config.MAX_VERTICAL_CONTINUOUS_VELOCITY * magnitude
	var delta_velocity_cap := _motionState.config.vertical_responsiveness * 25.00 * delta
	
	motionTarget.velocity.y = move_toward(
		motionTarget.velocity.y,
		target_vertical_velocity,
		delta_velocity_cap
	)

func _vertical_impulse(magnitude: float) -> void:
	_motionState.motionTarget.velocity.y += (magnitude * _motionState.config.MAX_VERTICAL_IMPULSE_VELOCITY)
