class_name IntentResolution
extends RefCounted

func execute(
	intentBearingInput: InputInterface.IntentBearingInput,
	referenceBasis: ViewIntentMediation.ReferenceBasis,
	physicalActorState: RealizationAuthority.PhysicalActorState # Previous frame
) -> void:
	pass

func produce() -> SemanticIntent:
	return SemanticIntent.new()

class SemanticIntent extends RefCounted:
	pass
