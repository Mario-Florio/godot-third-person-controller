class_name TracerAPI
extends RefCounted

const NULL_TOKEN := &"NULL_TOKEN"

var _config: ITracerConfig
var _tracer: ITracer
var _token_span_map  : Dictionary[StringName, ITracer.ISpan]
var _span_config_map : Dictionary[StringName, ISpanConfig]

func _init(config: ITracerConfig, tracer: ITracer, span_config_map: Dictionary[StringName, ISpanConfig]) -> void:
	_config = config
	_tracer = tracer
	_span_config_map = span_config_map

func START_SPAN(name: StringName) -> StringName:
	if _config.ENABLED == false: return NULL_TOKEN
	if _span_config_map.get(name).ENABLED == false: return NULL_TOKEN
	
	var span := _tracer.start_span(name)
	var token := _generate_token()
	while token == NULL_TOKEN: token = _generate_token()
	
	_token_span_map.set(token, span)
	return token

func END_SPAN(token: StringName) -> void:
	if token == NULL_TOKEN: return
	
	var span: ITracer.ISpan = _token_span_map.get(token)
	span.end()
	_token_span_map.erase(token)

func ADD_EVENT(
	token: StringName,
	event_name: StringName,
	event_attributes: Dictionary[StringName, Variant] = {}
) -> void:
	
	if token == NULL_TOKEN: return
	
	var span: ITracer.ISpan = _token_span_map.get(token)
	var span_config: ISpanConfig = _span_config_map.get(span.name)
	if span_config.ENABLED == false: return
	
	var event_config: IEventConfig = span_config.getEvents().get(event_name)
	if event_config.ENABLED == false: return
	
	_disable_attributes(event_config.getAttributes(), event_attributes)
	
	_token_span_map.get(token).add_event(event_name, event_attributes)

func ADD_ATTRIBUTE(token: StringName, key: StringName, value: Variant) -> void:
	if token == NULL_TOKEN: return
	
	var span: ITracer.ISpan = _token_span_map.get(token)
	span.set_attribute(key, value)

func END_FRAME() -> void:
	_tracer.end_frame()

# Utils
func _generate_token() -> StringName:
	const chars = "abcdefghijklmnopqrstuvwxyz0123456789"
	var id = &""
	for i in 16:
		id += chars[randi() % chars.length()]
	return id

func _disable_attributes(enabled_map: Dictionary[StringName, bool], event_attributes: Dictionary) -> void:
	for key: StringName in event_attributes.keys():
		var value: Variant = event_attributes.get(key)
		if enabled_map.get(key) == false:
			event_attributes.erase(key)
		
		elif value is Dictionary:
			_disable_attributes(enabled_map, value)
