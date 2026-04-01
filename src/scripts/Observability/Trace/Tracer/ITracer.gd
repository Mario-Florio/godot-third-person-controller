@abstract
class_name ITracer
extends RefCounted

@abstract
func _init(config: ITracerConfig) -> void

@abstract
func start_span(name: StringName) -> ISpan

@abstract
func end_span(span: ISpan) -> void

@abstract
func end_frame() -> void

@abstract
class ISpan extends RefCounted:
	var name: StringName
	
	var id        : StringName
	var trace_id  : StringName
	var parent_id : StringName
	
	var start_time : int
	var end_time   : int
	
	var attributes : Dictionary[StringName, Variant] = {}
	var events     : Array[IEvent] = []
	
	@abstract
	func _init(tracer: ITracer, _name: StringName, parent: ISpan) -> void
	
	@abstract
	func add_event(event_name: StringName, event_attributes: Dictionary[StringName, Variant] = {}) -> ISpan
	
	@abstract
	func set_attribute(key: StringName, value: Variant) -> ISpan
	
	@abstract
	func end() -> void

@abstract
class IEvent extends RefCounted:
	var name       : StringName
	var timestamp  : int
	var attributes : Dictionary[StringName, Variant] = {}
	
	@abstract
	func _init(_name: StringName) -> void
	
	@abstract
	func set_attributes(_attributes: Dictionary) -> IEvent
