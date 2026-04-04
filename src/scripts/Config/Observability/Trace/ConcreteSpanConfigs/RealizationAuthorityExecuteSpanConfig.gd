class_name RealizationAuthorityExecuteSpanConfig
extends ISpanConfig

@export_group("Events")
@export var MOTION_PROPOSALS_CREATED: MotionProposalsCreatedEventConfig

var _setup := false

func setup(motionProposalsCreated: MotionProposalsCreatedEventConfig = null) -> RealizationAuthorityExecuteSpanConfig:
	if _setup == true: return
	
	_setup = true
	
	if motionProposalsCreated != null: MOTION_PROPOSALS_CREATED = motionProposalsCreated
	elif MOTION_PROPOSALS_CREATED == null: MOTION_PROPOSALS_CREATED = MotionProposalsCreatedEventConfig.new()
	
	return self

func getEvents() -> Dictionary[StringName, IEventConfig]:
	return { TraceFacade.EventNames.MOTION_PROPOSALS_CREATED: MOTION_PROPOSALS_CREATED }
