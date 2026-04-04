class_name RealizationAuthority
extends RefCounted

# Domain Controllers
var _motionAuthority: MotionAuthority
var _positionAuthority: PositionAuthority

# Intermediaries / Adapters
var _proposalFactory := ProposalFactory.new()

# System Context
var _tracerAPI: TracerAPI

func _init(motionAuthority: MotionAuthority, tracerAPI: TracerAPI) -> void:
	_motionAuthority = motionAuthority
	_tracerAPI = tracerAPI

func execute(
	delta: float,
	semanticIntent: IntentResolution.SemanticIntent
) -> void:
	
	var span_token := _tracerAPI.START_SPAN(Observability.SpanNames.REALIZATION_AUTHORITY_EXECUTE)
	
	var proposals := _proposalFactory.provideMotionProposals(semanticIntent.intents())
	_tracerAPI.ADD_EVENT(
		span_token,
		Observability.EventNames.MOTION_PROPOSALS_CREATED,
		{
			Observability.AttributeNames.AMOUNT: proposals.size(),
			Observability.AttributeNames.MOTION_PROPOSALS: InstrumentationAdapter.formatMotionProposalsRecord(proposals)
		}
	)
	
	_motionAuthority.execute(
		delta,
		MotionAuthority.Payload.new(
			proposals
		)
	)
	
	if _positionAuthority:
		_positionAuthority.execute()
	
	_tracerAPI.END_SPAN(span_token)

func produce() -> PhysicalActorState:
	return PhysicalActorState.new(_motionAuthority)

func setPositionAuthority(positionAuthority: PositionAuthority) -> void:
	_positionAuthority = positionAuthority

class PhysicalActorState extends RefCounted:
	# Motion Snap
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
