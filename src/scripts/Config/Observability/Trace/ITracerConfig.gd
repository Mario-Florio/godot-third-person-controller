@abstract
class_name ITracerConfig
extends Resource

enum ProcessorType { SIMPLE, BATCH }
enum ExporterType { CONSOLE, FILE }

@export var ENABLED := false

@export_group("Processor")
@export var PROCESSOR := ProcessorType.SIMPLE

@export_group("Exporter")
@export var EXPORTER := ExporterType.CONSOLE
