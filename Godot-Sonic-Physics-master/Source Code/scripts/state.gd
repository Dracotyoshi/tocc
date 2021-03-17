# Interface for states
extends Node

func enter(_host: PlayerPhysics):
	return

func step(_host: PlayerPhysics, _delta: float):
	return

func exit(_host: PlayerPhysics):
	return

func animation_step(_host: PlayerPhysics, _animator: CharacterAnimator):
	return

func _on_animation_finished(_anim_name: String):
	pass
