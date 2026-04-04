class_name SyncTracer
extends ITracer

var _config: ITracerConfig

var _processor: ISpanProcessor
var _span_stack: Array[Span] = []

func _init(config: ITracerConfig, processor: ISpanProcessor) -> void:
	_config = config
	_processor = processor

func start_span(_name: StringName) -> ISpan:
	var parent: Span = _span_stack.back() if _span_stack.size() > 0 else null
	
	var span := Span.new(self, _name, parent)
	
	_span_stack.push_back(span)
	return span

func end_span(span: ISpan) -> void:
	assert(_span_stack.back().id == span.id, "Span %s is not at the top of span stack [Tracer.export_span]" % [span.name])
	_span_stack.pop_back()
	_processor.on_span_end(span)

func end_frame() -> void:
	_processor.on_frame_end()

class Span extends ITracer.ISpan:
	var _tracer: ITracer
	
	func _init(tracer: ITracer, _name: StringName, parent: Span) -> void:
		_tracer = tracer
		name = _name
		start_time = Time.get_ticks_usec()
		
		id = _generate_uid()
		
		if parent:
			trace_id = parent.trace_id
			parent_id = parent.id
		else:
			trace_id = _generate_uid()

	func add_event(_name: StringName, _attributes := {}) -> Span:
		var event := Event.new(_name)
		if _attributes:
			event.set_attributes(_attributes)
		
		events.append(event)
		return self
	
	func set_attribute(_key: StringName, _value: Variant) -> Span:
		assert(!attributes.has(_key), "Span already has attribute [Tracer.Span.set_attribute]")

		attributes.set(_key, _value)
		return self
	
	func end() -> void:
		end_time = Time.get_ticks_usec()
		_tracer.end_span(self)
	
	# Utils
	func _generate_uid() -> StringName:
		const chars = "abcdefghijklmnopqrstuvwxyz0123456789"
		var uid = ""
		for i in 16:
			uid += chars[randi() % chars.length()]
		return uid

class Event extends ITracer.IEvent:
	func _init(_name: StringName) -> void:
		name = _name
		timestamp = Time.get_ticks_usec()
	
	func set_attributes(_attributes: Dictionary) -> Event:
		attributes = _attributes
		return self
