## Read-only wrapper for arrays.
## Does not support inherent recursive wrapping for nested objects (which are passed by reference).
class_name ReadOnlyArray
extends RefCounted

var _array: Array

func _init(array: Array) -> void:
	_array = array

func size() -> int:
	return _array.size()

func read(index: int) -> Variant:
	assert(not _out_of_bounds(index), "Index is out of bounds")
	return _array[index]

# Utils
func _out_of_bounds(index: int) -> bool:
	if index > size() or index < 0: return true
	return false
