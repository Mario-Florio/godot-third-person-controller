class_name CameraMount
extends ViewInterface

@export var config := CameraConfig.new()

var MIN_PITCH := -PI / 3.0
var MAX_PITCH := PI / 3.0

var horizontal_sensitivity: float
var vertical_sensitivity: float
var _pitch := 0.0
var _yaw := 0.0

func _ready() -> void:
	horizontal_sensitivity = config.horizontal_sensitivity
	vertical_sensitivity = config.vertical_sensitivity

# Methods
func activate() -> void:
	view.current = true

func deactivate() -> void:
	view.current = false

func _physics_process(_delta: float) -> void:
	_apply_rotation()

func adjust_pitch(pitch: float) -> void:
	_pitch += deg_to_rad(pitch * vertical_sensitivity)
	_pitch = clamp(_pitch, MIN_PITCH, MAX_PITCH)

func adjust_yaw(yaw: float) -> void:
	_yaw += deg_to_rad(yaw * horizontal_sensitivity)

# Utils
func _apply_rotation() -> void:
	rotation.x = _pitch
	rotation.y = _yaw