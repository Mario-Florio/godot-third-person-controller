@abstract
class_name ISpanConfig
extends Resource

@export var ENABLED := false

const NULL_DICT := {}

func getAttibutes() -> Dictionary[StringName, bool]:
	return NULL_DICT

func getEvents() -> Dictionary[StringName, IEventConfig]:
	return NULL_DICT
