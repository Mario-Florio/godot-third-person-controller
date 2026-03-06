class_name MotionAuthority
extends RefCounted

enum MotionState { STILL, GROUNDED, AIRBORNE, ROOT_MOTION }
enum ForceApplication { CONTINUOUS, IMPULSE }

## Domains cross-module state.
## Not to be confused with "MotionState".
class State extends RefCounted:
	var config       : MotionConfig
	var motionTarget : CharacterBody3D
	
	# Accepted proposals
	## Currently accepted Horizontal Proposal.
	## Ephemeral; must be reset every frame.
	var horizontalProposal: MotionProposal.Horizontal
	## Currently accepted Rotational Proposal.
	## Ephemeral; must be reset every frame.
	var rotationalProposal: MotionProposal.Rotational
	## Currently accepted Vertical Proposal.
	## Ephemeral; must be reset every frame.
	var verticalProposal: MotionProposal.Vertical
	
	# Physical Actor State
	var curr_motion_state         := MotionState.STILL
	var last_position             := Vector3.ZERO
	
	func _init(_config: MotionConfig, _motionTarget: CharacterBody3D) -> void:
		config = _config
		motionTarget = _motionTarget

var _motionState       : State
var _proposalReviewer  : ProposalReviewer
var _motionResolver    : MotionResolver
var _invariantEnforcer : InvariantEnforcer

func _init(config: MotionConfig, motionTarget: CharacterBody3D) -> void:
	_motionState = State.new(config, motionTarget)
	_proposalReviewer = ProposalReviewer.new(_motionState)
	_motionResolver = MotionResolver.new(_motionState)
	_invariantEnforcer = InvariantEnforcer.new(_motionState)

func execute(delta: float, payload: Payload) -> void:
	_update_state()
	_proposalReviewer.review(payload.proposals)
	_motionResolver.resolve(delta)
	_invariantEnforcer.enforce(delta)
	_motionState.motionTarget.move_and_slide()

func export(snapshot: Snapshot) -> void:
	snapshot.motion_state = _motionState.curr_motion_state
	snapshot.global_transform = _motionState.motionTarget.global_transform
	snapshot.last_position = _motionState.last_position
	snapshot.max_horizontal_speed = _motionState.config.MAX_HORIZONTAL_SPEED
	snapshot.speed = _motionState.motionTarget.velocity.length()

# Utils
func _update_state() -> void:
	# Set MotionState
	if !(_motionState.motionTarget.velocity.length() > 0.0) and _motionState.motionTarget.is_on_floor():
		_motionState.curr_motion_state = MotionState.STILL
	
	elif _motionState.motionTarget.is_on_floor():
		_motionState.curr_motion_state = MotionState.GROUNDED
	
	else:
		_motionState.curr_motion_state = MotionState.AIRBORNE
	
	# Discard Proposals (from previous frame)
	_motionState.horizontalProposal = null
	_motionState.rotationalProposal = null
	_motionState.verticalProposal = null
	
	# Update last_position
	_motionState.last_position = _motionState.motionTarget.global_position

class Payload extends RefCounted:
	var proposals: Array[MotionProposal]
	
	func _init(_proposals: Array[MotionProposal]) -> void:
		proposals = _proposals

class Snapshot extends RefCounted:
	var motion_state: MotionState
	var global_transform: Transform3D
	var last_position: Vector3
	var max_horizontal_speed: float
	var speed: float
	
	func _init(motionAuthority: MotionAuthority) -> void:
		motionAuthority.export(self)
