class_name RealizationAuthority
extends RefCounted

func execute(
	delta: float,
	intentBearingInput: InputInterface.IntentBearingInput,
	referenceBasis: ViewIntentMediation.ReferenceBasis,
	semanticIntent: IntentResolution.SemanticIntent
) -> void:
	pass

func produce() -> PhysicalActorState:
	return PhysicalActorState.new()

class PhysicalActorState extends RefCounted:
	pass
