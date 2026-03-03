class_name RealizationAuthority
extends RefCounted

var _motionAuthority: MotionAuthority

# Intermediaries / Adapters
var _proposalFactory := ProposalFactory.new()

func _init(motionAuthority: MotionAuthority) -> void:
	_motionAuthority = motionAuthority

func execute(
	delta: float,
	semanticIntent: IntentResolution.SemanticIntent
) -> void:
	
	_motionAuthority.execute(
		delta,
		MotionAuthority.Payload.new(
			_proposalFactory.provideMotionProposals(semanticIntent.intents())
		)
	)

func produce() -> PhysicalActorState:
	return PhysicalActorState.new(_motionAuthority)

class PhysicalActorState extends RefCounted:
	var _motion_state: StringName
	var _global_transform: Transform3D
	var _last_position: Vector3
	var _max_horizontal_speed: float
	var _speed: float
	
	func _init(motionAuthority: MotionAuthority) -> void:
		var motionSnap := MotionAuthority.Snapshot.new(motionAuthority)
		_motion_state = _convertMotionState(motionSnap.motion_state)
		_global_transform = motionSnap.global_transform
		_last_position = motionSnap.last_position
		_max_horizontal_speed = motionSnap.max_horizontal_speed
		_speed = motionSnap.speed
	
	# Getters
	func motion_state() -> StringName:
		return _motion_state
	
	func global_transform() -> Transform3D:
		return _global_transform
	
	func last_position() -> Vector3:
		return _last_position
	
	func max_horizontal_speed() -> float:
		return _max_horizontal_speed
	
	func speed() -> float:
		return _speed
	
	# Utils
	func _convertMotionState(motionState: MotionAuthority.MotionState) -> StringName:
		match motionState:
			
			MotionAuthority.MotionState.STILL:
				return "STILL"
			
			MotionAuthority.MotionState.GROUNDED:
				return "GROUNDED"
			
			MotionAuthority.MotionState.AIRBORNE:
				return "AIRBORNE"
		
		assert(
			false,
			"MotionState mismatch [RealizationAuthority.convertMotionState]"
		)
		return "STILL"
