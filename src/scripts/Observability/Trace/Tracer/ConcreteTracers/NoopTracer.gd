class_name NoopTracer
extends ITracer

func _init(_config: ITracerConfig) -> void:
	pass

func start_span(name: StringName) -> ISpan:
	return NoopSpan.new(self, name, null)

func end_span(_span: ISpan) -> void:
	pass

func end_frame() -> void:
	pass

class NoopSpan extends ITracer.ISpan:
	func _init(_tracer: NoopTracer, _name: StringName, _parent: ISpan) -> void:
		pass
	
	func add_event(_event_name: StringName, _event_attributes: Dictionary[StringName, Variant] = {}) -> ISpan:
		return self
	
	func set_attribute(_key: StringName, _value: Variant) -> ISpan:
		return self
	
	func end() -> void:
		pass

class NoopEvent extends ITracer.IEvent:
	
	func _init(_name: StringName) -> void:
		pass
	
	func set_attributes(_attributes: Dictionary) -> IEvent:
		return self
