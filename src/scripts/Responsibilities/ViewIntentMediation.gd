class_name ViewIntentMediation
extends RefCounted

func execute(intentBearingInput: InputInterface.IntentBearingInput) -> void:
	pass

func produce() -> ReferenceBasis:
	return ReferenceBasis.new()

class ReferenceBasis extends RefCounted:
	pass
