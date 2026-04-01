class_name PresentationMediation
extends RefCounted

# Domain Controllers
var _animationHandler: AnimationHandler
var _visuals: Node3D

# System Context
var _tracerAPI: TracerAPI

func _init(animationHandler: AnimationHandler, tracerAPI: TracerAPI) -> void:
	_animationHandler = animationHandler
	_tracerAPI = tracerAPI

func execute(
	delta: float,
	referenceBasis: ViewIntentMediation.ReferenceBasis,
	semanticIntent: IntentResolution.SemanticIntent,
	physicalActorState: RealizationAuthority.PhysicalActorState
) -> void:
	
	var span_token := _tracerAPI.START_SPAN(Observability.SpanNames.PRESENTATION_MEDIATION_EXECUTE)
	
	if _animationHandler:
		var local_orientation := _derive_local_orientation(
			referenceBasis.global_transform().basis,
			physicalActorState.global_transform().basis,
			semanticIntent.bounded()
		)
		
		var local_velocity := _derive_local_velocity(
			delta,
			physicalActorState.global_transform().origin,
			physicalActorState.last_position(),
			local_orientation
		)
		
		_animationHandler.execute(AnimationHandler.Payload.new(
			physicalActorState.motion_state(),
			local_velocity,
			physicalActorState.max_horizontal_speed(),
			physicalActorState.speed()
		))
	
	_tracerAPI.END_SPAN(span_token)

func setAnimationHandler(animationHandler: AnimationHandler) -> void:
	_animationHandler = animationHandler

func setVisuals(visuals: Node3D) -> void:
	_visuals = visuals

func align_visual_pivot_offset(pivot_offset: float) -> void:
	if _visuals == null: return
	if pivot_offset == null: return
	
	if _visuals.position.z != pivot_offset:
		_visuals.position.z = pivot_offset

# Utils
## Determines current orientation of characters motion 
## (bounded to active view or characters forward-facing direction).
func _derive_local_orientation(active_view_orientation: Basis, character_body_orientation: Basis, bounded: bool) -> Basis:
	return (
		active_view_orientation if bounded
		else character_body_orientation
	)

## Determines local velocity of character body in relation to current orientation.
## Current orientation can either be bounded to reference-basis (via active view)
## or based on character bodies forward-facing direction.
## This value allows for convenient plugin to blend-positions.
func _derive_local_velocity(
	delta: float,
	global_position: Vector3,
	last_position: Vector3,
	local_orientation: Basis
) -> Vector2:
	
	# 1. Compute horizontal displacement / velocity
	var displacement = global_position - last_position
	
	# Ignore vertical motion
	displacement.y = 0
	
	if displacement.length() < 0.01:
		return Vector2.ZERO
	
	var velocity_world = displacement / delta
	var move_dir = velocity_world.normalized()
	
	# 2. Get reference basis
	var forward = -local_orientation.z.normalized()  # world forward in reference frame
	var right = local_orientation.x.normalized()     # world right in reference frame
	
	# 3. Project velocity onto reference basis
	var local_x = move_dir.dot(right)   # left/right
	var local_y = move_dir.dot(forward) # forward/back
	
	# 4. Normalize to [-1,1]
	var magnitude = Vector2(local_x, local_y).length()
	if magnitude > 1.0:
		return Vector2(local_x, local_y).normalized()
	else:
		return Vector2(local_x, local_y)
