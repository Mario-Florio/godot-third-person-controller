class_name SimpleSpanProcessor
extends ISpanProcessor

var _exporter: ISpanExporter

func _init(exporter: ISpanExporter) -> void:
	_exporter = exporter

func on_span_end(span: ITracer.ISpan) -> void:
	_exporter.export(span)
