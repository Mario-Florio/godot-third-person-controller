class_name ThirdPersonController
extends Node3D

# Resources
@export var config := ThirdPersonControllerConfig.new()

@onready var intentRealizationPipeline := IntentRealizationPipeline.new()

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	intentRealizationPipeline.setup(config)

func _input(event: InputEvent) -> void:
	intentRealizationPipeline.notify(event)

func _physics_process(delta: float) -> void:
	intentRealizationPipeline.run(delta)
