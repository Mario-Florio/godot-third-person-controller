class_name BatchSpanProcessor
extends ISpanProcessor

var _exporter: ISpanExporter

func _init(exporter: ISpanExporter) -> void:
	_exporter = exporter

var _span_buffer: Array[ITracer.ISpan] = []
var _max_batch_size := 512         # 256-512 is a reasonable range;
								   # consider 1-50 for Console export
var _max_flush_delay_us := 1000000 # 1-2 seconds (1,000,000 - 2,000,000 us) is reasonable range;
								   # consider 0-100,000 us for Console export
var _last_flush_time_us := Time.get_ticks_usec()

func on_span_end(span: ITracer.ISpan) -> void:
	_span_buffer.append(span)
	
	if _span_buffer.size() >= _max_batch_size:
		_flush()

func on_frame_end() -> void:
	var elapsed_flush_time := Time.get_ticks_usec() - _last_flush_time_us
	if elapsed_flush_time >= _max_flush_delay_us:
		_flush()

func force_flush() -> void:
	_flush()

# Utils
func _flush() -> void:
	if _span_buffer.is_empty(): return
	
	_exporter.export_batch(_span_buffer)
	
	_span_buffer.clear()
	_last_flush_time_us = Time.get_ticks_usec()
