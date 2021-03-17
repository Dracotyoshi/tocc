extends KinematicBody2D
class_name PlayerPhysics

export(float) var ACC: float = 2.8125
export(float) var DEC: float = 30
export(float) var ROLLDEC: float = 7.5
export(float) var FRC: float = 2.8125
export(float) var SLP: float = 7.5
export(float) var SLPROLLUP: float = 4.6875
export(float) var SLPROLLDOWN: float = 18.75
export(float) var TOP: float = 360
export(float) var TOPROLL: float = 960
export(float) var JMP: float = 390
export(float) var FALL: float = 150
export(float) var AIR: float = 5.625
export(float) var GRV: float = 13.125

onready var player_camera: Node2D = $'../PlayerCamera'
onready var player_vfx: Node2D = $Characters/VFX
onready var high_collider: CollisionShape2D = $HighCollider
onready var low_collider: CollisionShape2D = $LowCollider
onready var left_ground: RayCast2D = $LeftGroundSensor
onready var right_ground: RayCast2D = $RightGroundSensor
onready var left_wall: RayCast2D = $LeftWallSensor
onready var right_wall: RayCast2D = $RightWallSensor
onready var character: Node2D = $Characters
onready var animation: AnimationPlayer = $Characters/Sonic/AnimationPlayer
onready var audio_player: Node2D = $AudioPlayer

var gsp : float
var velocity : Vector2
var ground_mode : int
var control_locked : bool
var control_unlock_time: float = 0.5
var control_unlock_timer : float
var can_fall : bool
var is_ray_colliding : bool
var is_grounded : bool
var ground_point : Vector2
var ground_normal : Vector2
var has_jumped : bool
var is_rolling : bool
var is_braking : bool
var is_wall_left : bool
var is_wall_right : bool
var is_pushing : bool
var is_looking_down : bool
var is_looking_up : bool

func _ready() -> void:
	control_unlock_timer = control_unlock_time

func _process(delta: float) -> void:
	var roll_anim: bool = animation.current_animation == 'Rolling'
	high_collider.disabled = roll_anim
	low_collider.disabled = !roll_anim
	left_ground.position.x = -9 if !roll_anim else -7
	right_ground.position.x = 9 if !roll_anim else 7
	if (control_locked and is_grounded) or control_unlock_timer < control_unlock_time:
		control_unlock_timer -= delta
		if control_unlock_timer <= 0:
			control_unlock_timer = control_unlock_time
			control_locked = false

func physics_step() -> void:
	position.x = max(position.x, 9.0)
	var ground_ray = get_ground_ray()
	is_ray_colliding = true if ground_ray != null else false
	if is_on_ground():
		is_grounded = true
	if is_grounded and is_ray_colliding:
		ground_point = ground_ray.get_collision_point()
		ground_normal = ground_ray.get_collision_normal()
		ground_mode = int(round(rad2deg(ground_angle()) / 90.0)) % 4
		ground_mode = 2 if ground_mode == -2 else ground_mode
	else:
		ground_mode = 0
		ground_normal = Vector2(0, -1)
		is_grounded = false
	is_wall_left = left_wall.is_colliding() or position.x - 9 <= 0
	is_wall_right = right_wall.is_colliding()

func fall_from_ground() -> bool:
	if abs(gsp) < FALL and ground_mode != 0:
		var angle = abs(rad2deg(ground_angle()))
		control_locked = true
		if angle >= 90 and angle <= 180:
			ground_mode = 0
			return true
		return false
	return false

func snap_to_ground() -> void:
	rotation_degrees = -rad2deg(ground_angle())
	velocity += -ground_normal * 150

func ground_reacquisition() -> void:
	var angle = abs(rad2deg(ground_angle()))
	if angle >= 0 and angle < 22.5:
		gsp = velocity.x
	elif angle >= 22.5 and angle < 45.0:
		if abs(velocity.x) > velocity.y:
			gsp = velocity.x
		else:
			gsp = velocity.y * .5 * -sign(sin(ground_angle()))
	elif angle >= 45.0 and angle < 90:
		if abs(velocity.x) > velocity.y:
			gsp = velocity.x
		else:
			gsp = velocity.y * -sign(sin(ground_angle()))
	rotation_degrees = -rad2deg(ground_angle())

func ground_angle() -> float:
	return ground_normal.angle_to(Vector2(0, -1))

func is_on_ground() -> bool:
	var ground_ray = get_ground_ray()
	if ground_ray != null:
		var point = ground_ray.get_collision_point()
		var normal = ground_ray.get_collision_normal()
		if abs(rad2deg(normal.angle_to(Vector2(0, -1)))) < 90:
			return position.y + 20 > point.y and velocity.y >= 0
	return false

func get_ground_ray():
	can_fall = true
	if !left_ground.is_colliding() and !right_ground.is_colliding():
		return null
	elif !left_ground.is_colliding() and right_ground.is_colliding():
		return right_ground
	elif !right_ground.is_colliding() and left_ground.is_colliding():
		return left_ground
	can_fall = false
	var left_point : float
	var right_point : float
	match ground_mode:
		0:
			left_point = -left_ground.get_collision_point().y
			right_point = -right_ground.get_collision_point().y
		1:
			left_point = -left_ground.get_collision_point().x
			right_point = -right_ground.get_collision_point().x
		2:
			left_point = left_ground.get_collision_point().y
			right_point = right_ground.get_collision_point().y
		-1:
			left_point = left_ground.get_collision_point().x
			right_point = right_ground.get_collision_point().x
	if left_point >= right_point:
		return left_ground
	else:
		return right_ground
