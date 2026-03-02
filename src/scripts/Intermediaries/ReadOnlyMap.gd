## Read-only wrapper for any object that has a key -> value relationship.
## Does not support inherent recursive wrapping for nested objects (which are passed by reference).
class_name ReadOnlyMap
extends RefCounted

var _map: Variant

func _init(map: Variant) -> void:
	_map = map

## Check if map has property.
func has(property: StringName) -> bool:
	return property in _map

## Read property from map.
## Internally asserts has(property);
## consider checking if map has property prior to read if logic doesn't depend on a returned value.
func read(property: StringName) -> Variant:
	assert(has(property), "Property does not exist on map")
	
	return _map[property]

## Returns private _map.
## Used to handle type checks in adapter layer.
## Should not be used to manipulate _map directly.
func unwrap() -> Variant:
	return _map
