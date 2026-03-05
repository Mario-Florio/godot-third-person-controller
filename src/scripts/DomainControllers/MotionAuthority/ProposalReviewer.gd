class_name ProposalReviewer
extends RefCounted

# Using
const ForceApplication := MotionAuthority.ForceApplication
const MotionState      := MotionAuthority.MotionState

# Rules
var HORIZONTAL_AIRBORNE_INTENT_ALLOWED := false
var ROTATIONAL_AIRBORNE_INTENT_ALLOWED := false
var VERTICAL_AIRBORNE_IMPULSE_ALLOWED  := false

var _motionState: MotionAuthority.State

func _init(motionState: MotionAuthority.State) -> void:
	_motionState = motionState
	HORIZONTAL_AIRBORNE_INTENT_ALLOWED = _motionState.config.HORIZONTAL_AIRBORNE_INTENT_ALLOWED
	ROTATIONAL_AIRBORNE_INTENT_ALLOWED = _motionState.config.ROTATIONAL_AIRBORNE_INTENT_ALLOWED
	VERTICAL_AIRBORNE_IMPULSE_ALLOWED = _motionState.config.VERTICAL_AIRBORNE_IMPULSE_ALLOWED

func review(proposals: Array[MotionProposal]) -> void:
	for proposal in proposals:
		proposal.submit(self) # calls `self.review_[proposal type]`

func review_horizontal(proposal: MotionProposal.Horizontal) -> void:
	if ((_motionState.horizontalProposal != null) and
		(_motionState.horizontalProposal.priority < proposal.priority)): return
	
	# Apply rule: Horizontal Airborne Intent
	if (!HORIZONTAL_AIRBORNE_INTENT_ALLOWED and
		(_motionState.curr_motion_state == MotionState.AIRBORNE)): return
	
	_motionState.horizontalProposal = proposal

func review_rotational(proposal: MotionProposal.Rotational) -> void:
	if ((_motionState.rotationalProposal != null) and
		(_motionState.rotationalProposal.priority < proposal.priority)): return
	
	# Apply rule: Rotational Airborne Intent
	if (!ROTATIONAL_AIRBORNE_INTENT_ALLOWED and
		(_motionState.curr_motion_state == MotionState.AIRBORNE)): return
	
	_motionState.rotationalProposal = proposal

func review_vertical(proposal: MotionProposal.Vertical) -> void: # Called through double-dispatch via the MotionProposal
	# REJECTED: Highest priority (lowest value) always wins
	if ((_motionState.verticalProposal != null) and
		(_motionState.verticalProposal.priority < proposal.priority)): return
	
	# Apply rule: Vertical Impulse allowed while Airborne
	if ((_motionState.curr_motion_state == MotionState.AIRBORNE) and
		(proposal.application == ForceApplication.IMPULSE) and
		(!VERTICAL_AIRBORNE_IMPULSE_ALLOWED)): return
	
	_motionState.verticalProposal = proposal
