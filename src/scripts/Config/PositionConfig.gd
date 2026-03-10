class_name PositionConfig
extends Resource

## Adjusts the collision body offset from central pivot point.
## Creates orbitting effect when rotating.
## Note: Visuals must be set for visual presentation of pivot offset.
## Scale: 0 = 0.0; 1 = -0.2
@export_range(0.0, 1.0) var PIVOT_OFFSET := 0.00:
	set(value):
		if value == PIVOT_OFFSET: return
		
		PIVOT_OFFSET = (0 - (value * 0.2))
		pivot_offset_updated.emit(PIVOT_OFFSET)

signal pivot_offset_updated(pivot_offset: float)

func connectHandler(signalName: StringName, handler: Callable) -> void:
	if !has_signal(signalName):
		assert(false, "Signal doesn't exist [PositionConfig.connectHandler]")
	
	connect(signalName, handler)
