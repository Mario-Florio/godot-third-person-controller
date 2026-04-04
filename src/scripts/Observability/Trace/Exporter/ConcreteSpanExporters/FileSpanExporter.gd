class_name FileSpanExporter
extends ISpanExporter

const _ROOT_LOGS_PATH    := &"res://logs/"
const _DEBUG_FILE_PREFIX := &"debug."
const _LOG_SUFFIX        := &".log"

var _current_session: StringName
var _log_path: StringName

func _init() -> void:
	_current_session = Time.get_datetime_string_from_system()
	_log_path = _ROOT_LOGS_PATH + _DEBUG_FILE_PREFIX + _current_session + _LOG_SUFFIX

func export(span: ITracer.ISpan) -> void:
	_save_to_file(_span_to_dict(span))

func export_batch(spans: Array[ITracer.ISpan]) -> void:
	for span: ITracer.ISpan in spans:
		_save_to_file(_span_to_dict(span))

# Utils
func _save_to_file(content: Dictionary) -> void:
	var file := FileAccess.open(_log_path, FileAccess.READ_WRITE)
	if file == null: file = FileAccess.open(_log_path, FileAccess.WRITE_READ)
	file.seek_end()
	file.store_string(JSON.stringify(content, "", false) + '\n')
	file.close()

func _span_to_dict(span: ITracer.ISpan) -> Dictionary[StringName, Variant]:
	return {
		&"name": span.name,
		&"trace_id": span.trace_id,
		&"span_id": span.id,
		&"parent_id": span.parent_id,
		&"start_time": span.start_time,
		&"end_time": span.end_time,
		&"attributes": span.attributes,
		&"events": span.events
	}

func _generate_uid() -> StringName:
	const chars = "abcdefghijklmnopqrstuvwxyz0123456789"
	var id = &""
	for i in 16:
		id += chars[randi() % chars.length()]
	return id
