class_name InstrumentationAdapter
extends RefCounted

const HORIZONTAL  : StringName = TraceFacade.AttributeNames.HORIZONTAL
const ROTATIONAL  : StringName = TraceFacade.AttributeNames.ROTATIONAL
const VERTICAL    : StringName = TraceFacade.AttributeNames.VERTICAL
const PRIORITY    : StringName = TraceFacade.AttributeNames.PRIORITY
const MAGNITUDE   : StringName = TraceFacade.AttributeNames.MAGNITUDE
const YAW         : StringName = TraceFacade.AttributeNames.YAW

# Motion Intent Properties
const TEMPORALITY : StringName = TraceFacade.AttributeNames.TEMPORALITY
const DIRECTION   : StringName = TraceFacade.AttributeNames.DIRECTION

# Motion Proposal Properties
const APPLICATION   : StringName = TraceFacade.AttributeNames.APPLICATION
const PLANAR_VECTOR : StringName = TraceFacade.AttributeNames.PLANAR_VECTOR

static func formatMotionIntentsRecord(motionIntents: Array[MotionIntent]) -> Dictionary[StringName, Variant]:
	var formattedMotionIntents: Dictionary[StringName, Variant] = {}
	for intent: MotionIntent in motionIntents:
		if intent is MotionIntent.Horizontal:
			formattedMotionIntents[HORIZONTAL] = {}
			formattedMotionIntents[HORIZONTAL][PRIORITY] = intent.priority
			formattedMotionIntents[HORIZONTAL][TEMPORALITY] = intent.temporality
			formattedMotionIntents[HORIZONTAL][MAGNITUDE] = intent.magnitude
			formattedMotionIntents[HORIZONTAL][DIRECTION] = intent.direction
		
		if intent is MotionIntent.Rotational:
			formattedMotionIntents[ROTATIONAL] = {}
			formattedMotionIntents[ROTATIONAL][PRIORITY] = intent.priority
			formattedMotionIntents[ROTATIONAL][TEMPORALITY] = intent.temporality
			formattedMotionIntents[ROTATIONAL][MAGNITUDE] = intent.magnitude
			formattedMotionIntents[ROTATIONAL][YAW] = intent.yaw
		
		if intent is MotionIntent.Vertical:
			formattedMotionIntents[VERTICAL] = {}
			formattedMotionIntents[VERTICAL][PRIORITY] = intent.priority
			formattedMotionIntents[VERTICAL][TEMPORALITY] = intent.temporality
			formattedMotionIntents[VERTICAL][MAGNITUDE] = intent.magnitude
	
	return formattedMotionIntents

static func formatMotionProposalsRecord(motionProposals: Array[MotionProposal]) -> Dictionary[StringName, Variant]:
	var formattedMotionProposals: Dictionary[StringName, Variant] = {}
	for proposal: MotionProposal in motionProposals:
		if proposal is MotionProposal.Horizontal:
			formattedMotionProposals[HORIZONTAL] = {}
			formattedMotionProposals[HORIZONTAL][PRIORITY] = proposal.priority
			formattedMotionProposals[HORIZONTAL][APPLICATION] = proposal.application
			formattedMotionProposals[HORIZONTAL][MAGNITUDE] = proposal.magnitude
			formattedMotionProposals[HORIZONTAL][PLANAR_VECTOR] = proposal.planar_vector
		
		if proposal is MotionProposal.Rotational:
			formattedMotionProposals[ROTATIONAL] = {}
			formattedMotionProposals[ROTATIONAL][PRIORITY] = proposal.priority
			formattedMotionProposals[ROTATIONAL][APPLICATION] = proposal.application
			formattedMotionProposals[ROTATIONAL][MAGNITUDE] = proposal.magnitude
			formattedMotionProposals[ROTATIONAL][YAW] = proposal.yaw
		
		if proposal is MotionProposal.Vertical:
			formattedMotionProposals[VERTICAL] = {}
			formattedMotionProposals[VERTICAL][PRIORITY] = proposal.priority
			formattedMotionProposals[VERTICAL][APPLICATION] = proposal.application
			formattedMotionProposals[VERTICAL][MAGNITUDE] = proposal.magnitude
	
	return formattedMotionProposals
