class_name IntentResolution
extends RefCounted

var _locomotionSemantics: LocomotionSemantics

func _init(locomotionSemantics: LocomotionSemantics) -> void:
	_locomotionSemantics = locomotionSemantics

func execute(
	intentBearingInput: InputInterface.IntentBearingInput,
	referenceBasis: ViewIntentMediation.ReferenceBasis,
	physicalActorState: RealizationAuthority.PhysicalActorState # Previous frame
) -> void:
	
	_locomotionSemantics.execute(LocomotionSemantics.Payload.new()
		.addIntentBearingInput(
			intentBearingInput.move_vector(),
			intentBearingInput.focus(),
			_adaptSpeedIntent(intentBearingInput.speed_intent()),
			_deriveWorldState()
		).addReferenceBasis(
			_get_global_rotation_y(referenceBasis.global_transform()),
			_flatten_direction(referenceBasis.global_transform().basis.x), # lateral
			_flatten_direction(-referenceBasis.global_transform().basis.z) # forward direction (-z is forward)
		).addPhysicalActorState(
			# Hard-coded until Physical actor state provides motion states
			_adaptMotionState("STILL")
		)
	)

func produce() -> SemanticIntent:
	return SemanticIntent.new(_locomotionSemantics)

class SemanticIntent extends RefCounted:
	var _intents: ReadOnlyArray
	
	func _init(locomotionSemantics: LocomotionSemantics) -> void:
		var locomotionSnap := LocomotionSemantics.Snapshot.new(locomotionSemantics)
		var read_only_intents : Array[ReadOnlyMap]
		
		for intent in locomotionSnap.intents:
			var read_only_intent := ReadOnlyMap.new(intent)
			read_only_intents.append(read_only_intent)
		
		_intents = ReadOnlyArray.new(read_only_intents)
	
	# Getters
	func intents() -> ReadOnlyArray:
		return _intents

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
