extends Node2D

onready var vfx: Dictionary = {
	"ChargeDust" : $ChargeDust/AnimationPlayer,
	"InstaShield" : $InstaShield/AnimationPlayer,
}

var effect_to_stop

func _process(_delta: float) -> void:
	if effect_to_stop is String:
		if effect_to_stop != null:
			if !vfx[effect_to_stop].is_playing():
				stop(effect_to_stop)

func play(effect_name: String, stop_on_finish: bool) -> void:
	vfx[effect_name].get_parent().visible = true
	vfx[effect_name].play(effect_name)
	if stop_on_finish:
		effect_to_stop = effect_name

func stop(effect_name: String) -> void:
	vfx[effect_name].get_parent().visible = false
	vfx[effect_name].stop(true)
