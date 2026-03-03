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
	
	func _init(motionAuthority: MotionAuthority) -> void:
		var motionSnap := MotionAuthority.Snapshot.new(motionAuthority)
		_motion_state = _convertMotionState(motionSnap.motion_state)
	
	# Getters
	func motion_state() -> StringName:
		return _motion_state
	
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
