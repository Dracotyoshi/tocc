extends Node

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_full_screen"):
		OS.window_fullscreen = !OS.window_fullscreen
