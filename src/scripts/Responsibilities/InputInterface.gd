class_name InputInterface
extends RefCounted

func execute() -> void:
	pass

func produce() -> IntentBearingInput:
	return IntentBearingInput.new()

class IntentBearingInput extends RefCounted:
	pass
