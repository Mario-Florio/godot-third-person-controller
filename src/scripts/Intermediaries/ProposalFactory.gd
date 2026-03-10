class_name ProposalFactory
extends RefCounted

# Using
const TemporalCharacter := MotionIntent.TemporalCharacter
const ForceApplication  := MotionAuthority.ForceApplication
const HorizontalIntent  := MotionIntent.Horizontal
const RotationalIntent  := MotionIntent.Rotational
const VerticalIntent    := MotionIntent.Vertical

func provideMotionProposals(motionIntents: ReadOnlyArray) -> Array[MotionProposal]:
	var proposals: Array[MotionProposal] = []
	for i in range(motionIntents.size()):
		var intent: ReadOnlyMap = motionIntents.read(i)
		if intent == null: continue
		
		var application: ForceApplication
		match intent.read("temporality"):
			TemporalCharacter.IMPULSE:
				application = ForceApplication.IMPULSE
			TemporalCharacter.CONTINUOUS:
				application = ForceApplication.CONTINUOUS
			_:
				assert(false, "TemporalCharacter mismatch [ProposalFactory.provideProposals]")
		
		if intent.unwrap() is HorizontalIntent:
			proposals.append(MotionProposal.Horizontal.new(
				intent.read("priority"),
				application,
				intent.read("magnitude"),
				intent.read("direction")
			))
		
		elif intent.unwrap() is VerticalIntent:
			proposals.append(MotionProposal.Vertical.new(
				intent.read("priority"),
				application,
				intent.read("magnitude")
			))
		
		else: # intent is Rotational
			proposals.append(MotionProposal.Rotational.new(
				intent.read("priority"),
				application,
				intent.read("magnitude"),
				intent.read("yaw")
			))
	
	return proposals
