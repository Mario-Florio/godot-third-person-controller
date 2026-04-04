@abstract
class_name ISpanExporter
extends RefCounted

# Using
const ExporterType := ITracerConfig.ExporterType

func export(_span: ITracer.ISpan) -> void:
	pass

func export_batch(_spans: Array[ITracer.ISpan]) -> void:
	pass
