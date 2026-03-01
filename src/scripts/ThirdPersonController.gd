class_name ThirdPersonController
extends Node3D

# Resources
@export var config := ThirdPersonControllerConfig.new()

## Starting view for character. Required if not using dynamic view discovery.
@export var initialView: ViewInterface

@onready var intentRealizationPipeline := IntentRealizationPipeline.new()

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	intentRealizationPipeline.setup(config, initialView)

func _input(event: InputEvent) -> void:
	intentRealizationPipeline.notify(event)

func _physics_process(delta: float) -> void:
	intentRealizationPipeline.run(delta)
