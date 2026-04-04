class_name IntentResolution
extends RefCounted

# Domain Controllers
var _locomotionSemantics: LocomotionSemantics

# System Context
var _tracerAPI: TracerAPI

func _init(locomotionSemantics: LocomotionSemantics, tracerAPI: TracerAPI) -> void:
	_locomotionSemantics = locomotionSemantics
	_tracerAPI = tracerAPI

func execute(
	intentBearingInput: InputInterface.IntentBearingInput,
	referenceBasis: ViewIntentMediation.ReferenceBasis,
	physicalActorState: RealizationAuthority.PhysicalActorState # Previous frame
) -> void:
	
	var span_token := _tracerAPI.START_SPAN(Observability.SpanNames.INTENT_RESOLUTION_EXECUTE)
	
	_locomotionSemantics.execute(LocomotionSemantics.Payload.new()
		.addIntentBearingInput(
			intentBearingInput.move_vector(),
			intentBearingInput.focus(),
			_adaptSpeedIntent(intentBearingInput.speed_intent()),
			_deriveWorldState(),
			intentBearingInput.jump(),
			intentBearingInput.dash(),
			intentBearingInput.lift()
		).addReferenceBasis(
			_get_global_rotation_y(referenceBasis.global_transform()),
			_flatten_direction(referenceBasis.global_transform().basis.x), # lateral
			_flatten_direction(-referenceBasis.global_transform().basis.z) # forward direction (-z is forward)
		).addPhysicalActorState(
			_adaptMotionState(physicalActorState.motion_state())
		)
	)
	
	_tracerAPI.END_SPAN(span_token)

func produce() -> SemanticIntent:
	return SemanticIntent.new(_locomotionSemantics)

class SemanticIntent extends RefCounted:
	var _intents: ReadOnlyArray
	var _bounded: bool
	
	func _init(locomotionSemantics: LocomotionSemantics) -> void:
		var locomotionSnap := LocomotionSemantics.Snapshot.new(locomotionSemantics)
		var read_only_intents : Array[ReadOnlyMap]
		
		for intent in locomotionSnap.intents:
			var read_only_intent := ReadOnlyMap.new(intent)
			read_only_intents.append(read_only_intent)
		
		_intents = ReadOnlyArray.new(read_only_intents)
		_bounded = locomotionSnap.bounded
	
	# Getters
	func intents() -> ReadOnlyArray:
		return _intents
	
	func bounded() -> bool:
		return _bounded

# Utils
func _deriveWorldState() -> LocomotionSemantics.WorldState:
	# Hard-coded until Intent-bearing input provides relevant world awareness data
	return LocomotionSemantics.WorldState.ENGAGED

func _adaptSpeedIntent(speed_intent: StringName) -> LocomotionSemantics.SpeedTier:
	match speed_intent:
		"SLOW":
			return LocomotionSemantics.SpeedTier.SLOW
		
		"NORMAL":
			return LocomotionSemantics.SpeedTier.NORMAL
		
		"FAST":
			return LocomotionSemantics.SpeedTier.FAST
	
	assert(
		false,
		"SpeedIntent mismatch [IntentResolution._adaptSpeedIntent]"
	)
	return LocomotionSemantics.SpeedTier.SLOW

func _adaptMotionState(motionState: StringName) -> LocomotionSemantics.MotionState:
	match motionState:
		"STILL":
			return LocomotionSemantics.MotionState.STILL
		
		"GROUNDED":
			return LocomotionSemantics.MotionState.GROUNDED
		
		"AIRBORNE":
			return LocomotionSemantics.MotionState.AIRBORNE
		
	assert(
		false,
		"MotionState mismatch [IntentResolution._adaptMotionState]"
	)
	return LocomotionSemantics.MotionState.GROUNDED

func _get_global_rotation_y(transform: Transform3D) -> float:
	return transform.basis.get_euler().y

func _flatten_direction(direction: Vector3) -> Vector3:
	var _direction := direction.normalized()
	
	# Remove vertical influence
	_direction.y = 0
	
	# Restore consistent magnitude
	_direction = _direction.normalized()
	return _direction
