class_name InputConfig
extends Resource

enum InputMode { KEYBOARD_MOUSE }

@export var inputMode := InputMode.KEYBOARD_MOUSE

# Action names
const Actions := {
	"CAMERA_FOCUS": "camera_focus",
	"SWAP_SHOULDER": "swap_shoulder",
	"FORWARD": "forward",
	"BACKWARD": "backward",
	"LEFT": "left",
	"RIGHT": "right",
	"SPEED_UP": "speed_up",
	"SLOW_DOWN": "slow_down",
	"JUMP": "jump"
}

# Default bindings
@export var camera_focus_mouse_button: MouseButton = MOUSE_BUTTON_RIGHT
@export var shoulder_swap_key: Key = KEY_TAB
@export var forward_key: Key = KEY_W
@export var backward_key: Key = KEY_S
@export var left_key: Key = KEY_A
@export var right_key: Key = KEY_D
@export var speed_up_key: Key = KEY_SHIFT
@export var slow_down_key: Key = KEY_CTRL
@export var jump_key: Key = KEY_SPACE
