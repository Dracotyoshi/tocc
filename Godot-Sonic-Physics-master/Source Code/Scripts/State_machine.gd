extends Node

onready var host: PlayerPhysics = get_parent()
onready var states: Dictionary = {
	'OnGround' : $OnGround,
	'OnAir' : $OnAir,
	'SpinDash' : $SpinDash,
	'SuperPeelOut' : $SuperPeelOut,
	}

var current_state: String = 'OnGround'
var previous_state: String = ""

func _physics_process(delta: float) -> void:
	host.physics_step()
	var state_name = states[current_state].step(host, delta)
	if state_name:
		change_state(state_name)
	host.velocity = host.move_and_slide(host.velocity)
	states[current_state].animation_step(host, host.animation)
	host.player_camera.camera_step(host, delta)

func change_state(state_name: String) -> void:
	if state_name == current_state:
		return
	states[current_state].exit(host)
	previous_state = current_state
	current_state = state_name
	states[current_state].enter(host)

func _on_AnimationPlayer_animation_finished(anim_name: String):
	states[current_state]._on_animation_finished(anim_name)
