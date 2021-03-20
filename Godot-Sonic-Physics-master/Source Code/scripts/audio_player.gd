extends Node2D

onready var audios: Dictionary = {
	'jump' : $jump,
	'brake' : $brake,
	'spin' : $spin,
	'spin_dash_charge' : $SpinDashCharge,
	'spin_dash_release' : $SpinDashRelease,
	'peel_out_charge' : $PeelOutCharge,
	'peel_out_release' : $PeelOutRelease,
	'insta_shield' : $InstaShield,
}

func play(audio_name: String) -> void:
	audios[audio_name].play()

func stop(audio_name: String) -> void:
	audios[audio_name].stop()
