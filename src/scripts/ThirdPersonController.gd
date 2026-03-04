class_name ThirdPersonController
extends Node3D

# Resources
@export var config := ThirdPersonControllerConfig.new():
	set(value):
		config = value
		_attempt_init()

# Nodes
## Starting view for character. Required if not using dynamic view discovery.
@export var initialView   : ViewInterface:
	set(value):
		initialView = value
		_attempt_init()
@export var characterBody : CharacterBody3D:
	set(value):
		characterBody = value
		_attempt_init()
@export var animationTree : AnimationTree:
	set(value):
		animationTree = value
		_attempt_init()

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
	if characterBody == null: return
	
	intentRealizationPipeline = IntentRealizationPipeline.new()
	
	intentRealizationPipeline.setup(
		config,
		initialView,
		characterBody,
		animationTree
	)
	
	_initialized = true
