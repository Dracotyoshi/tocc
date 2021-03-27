# Interface for states
extends Node

func enter(_host: PlayerPhysics) -> void:
	return

func step(_host: PlayerPhysics, _delta: float) -> void:
	return

func exit(_host: PlayerPhysics) -> void:
	return

func animation_step(_host: PlayerPhysics, _animator: CharacterAnimator) -> void:
	return

func _on_animation_finished(_anim_name: String) -> void:
	pass
