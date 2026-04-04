@abstract
class_name ISpanProcessor
extends RefCounted

# Using
const ExporterType := ITracerConfig.ExporterType

func on_span_end(_span: ITracer.ISpan) -> void:
	pass

func on_frame_end() -> void:
	pass
