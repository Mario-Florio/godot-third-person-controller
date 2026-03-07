class_name PositionAuthority
extends RefCounted

var _config: PositionConfig
var _collisionBody: CollisionShape3D

func _init(config: PositionConfig, collisionBody: CollisionShape3D) -> void:
	_config = config
	_collisionBody = collisionBody
	
	on_pivot_offset_updated(_config.PIVOT_OFFSET)
	connectConfigHandler("pivot_offset_updated", on_pivot_offset_updated)

func execute() -> void:
	pass

func export(snapshot: Snapshot) -> void:
	snapshot.pivot_offset = _config.PIVOT_OFFSET

func setCollisionBody(collisionBody: CollisionShape3D) -> void:
	_collisionBody = collisionBody

func on_pivot_offset_updated(pivot_offset: float) -> void:
	_collisionBody.position.z = pivot_offset

func connectConfigHandler(signalName: StringName, handler: Callable) -> void:
	_config.connectHandler(signalName, handler)

class Snapshot extends RefCounted:
	var pivot_offset: float
	
	func _init(positionAuthority: PositionAuthority) -> void:
		positionAuthority.export(self)
