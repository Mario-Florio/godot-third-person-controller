class_name ThirdPersonController
extends Node3D

# Resources
@export var config := ThirdPersonControllerConfig.new():
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

# Infrastructure
var intentRealizationPipeline: IntentRealizationPipeline

var _initialized := false

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event: InputEvent) -> void:
	if !_initialized: return
	
	intentRealizationPipeline.notify(event)

func _physics_process(delta: float) -> void:
	if !_initialized: return
	
	intentRealizationPipeline.run(delta)

# Utils
func _attempt_init() -> void:
	if _initialized: return
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
