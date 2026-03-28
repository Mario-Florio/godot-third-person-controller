class_name ThirdPersonController
extends Node3D

# Resources
@export var config: ThirdPersonControllerConfig:
	set(value):
		if value == null: return
		
		config = value
		_attempt_init()

# Nodes
@export var characterBody: CharacterBody3D:
	set(value):
		if value == null: return
		
		characterBody = value
		_attempt_init()

## Starting view for character. Required if not using dynamic view discovery.
@export var initialView: ViewInterface:
	set(value):
		if value == null: return
		
		initialView = value
		
		if _initialized:
			intentRealizationPipeline.setInitialView(initialView)

@export var animationTree: AnimationTree:
	set(value):
		if value == null: return
		
		animationTree = value
		
		if _initialized:
			intentRealizationPipeline.setAnimationHandler(config.animationConfig, animationTree)

@export var viewProbe: ViewArea:
	set(value):
		if value == null: return
		
		viewProbe = value
		
		if _initialized:
			intentRealizationPipeline.setViewProbe(viewProbe)

@export var visuals: Node3D:
	set(value):
		if value == null: return
		
		visuals = value
		
		if _initialized:
			intentRealizationPipeline.setVisuals(visuals, _get_pivot_offset())

@export var collisionBody: CollisionShape3D:
	set(value):
		if value == null: return
		
		collisionBody = value
		
		if _initialized:
			intentRealizationPipeline.setPositionAuthority(config.positionConfig, collisionBody)

# Infrastructure
var intentRealizationPipeline: IntentRealizationPipeline

var _initialized := false
var _node_ready  := false

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if config == null:
		config = ThirdPersonControllerConfig.new()
	
	_node_ready = true

func _input(event: InputEvent) -> void:
	if !_initialized: return
	
	intentRealizationPipeline.notify(event)

func _physics_process(delta: float) -> void:
	if !_initialized: return
	
	intentRealizationPipeline.run(delta)

# Utils
func _attempt_init() -> void:
	if _initialized: return
	if !_node_ready: return
	if config == null: return
	if characterBody == null: return
	
	intentRealizationPipeline = IntentRealizationPipeline.new()
	
	intentRealizationPipeline.setup(
		config,
		characterBody
	)
	
	_initialized = true
	
	# Optional Dependencies setup
	if initialView != null:
		initialView = initialView # Apply dependencies via setter
	
	if animationTree != null:
		animationTree = animationTree # Apply dependencies via setter
	
	if viewProbe != null:
		viewProbe = viewProbe # Apply dependencies via setter
	
	if visuals != null:
		visuals = visuals # Apply dependencies via setter
	
	if collisionBody != null:
		collisionBody = collisionBody # Apply dependencies via setter

func _get_pivot_offset() -> float:
	if config == null: return 0.0
	if config.positionConfig == null: return 0.0
	if config.positionConfig.PIVOT_OFFSET == null: return 0.0

	return config.positionConfig.PIVOT_OFFSET
