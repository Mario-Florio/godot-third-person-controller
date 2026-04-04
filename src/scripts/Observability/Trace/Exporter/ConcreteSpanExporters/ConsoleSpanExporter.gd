class_name ConsoleSpanExporter
extends ISpanExporter

var parent_id: StringName
var child_spans: Array[ITracer.ISpan] = []

func export(span: ITracer.ISpan) -> void:
	_printSpan(span)

func export_batch(_spans: Array[ITracer.ISpan]) -> void:
	for span in _spans: export(span)

# Utils
func _printSpan(span: ITracer.ISpan) -> void:
	print("SPAN: ", span.name, " - ", (span.end_time - span.start_time), "ms")
	
	if span.attributes.size() > 0:
		print("  attributes: ", span.attributes)
	
	for event in span.events:
		print("  EVENT: ", event.name, " @ ", event.timestamp, "ms")
		print("    attributes:")
		_printDictionary(event.attributes, 2, 3)

func _printDictionary(dictionary: Dictionary, indentation: int, indentation_level: int) -> void:
	var white_space := ""
	for i in indentation * indentation_level:
		white_space += " "
	
	for key in dictionary.keys():
		if dictionary[key] is Dictionary:
			print(white_space, key, ": ")
			_printDictionary(dictionary[key], indentation, indentation_level+1)
		else:
			print(white_space, key, ": ", dictionary[key])
