class_name InputConfig
extends Resource

enum InputMode { KEYBOARD_MOUSE }

@export var inputMode := InputMode.KEYBOARD_MOUSE

# Action names
const Actions := {
	"CAMERA_FOCUS": "camera_focus",
	"SWAP_SHOULDER": "swap_shoulder"
}

# Default bindings
@export var camera_focus_mouse_button: MouseButton = MOUSE_BUTTON_RIGHT
@export var shoulder_swap_key: Key = KEY_TAB
