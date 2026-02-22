extends Node3D

@export var backwards = 1
@export var rotate_speed = 30
@export var move_speed = 20
@export var player_num = 1

var dead = false

@onready var backline: Node3D = $Backline
@onready var frontline: Node3D = $Frontline

var rotate_string = "0"
var moving_string = "1"

var current_side = "right"  # can be "left"
var target_rotations_dict = {
	"right": -67,  #67777777777!!!!!
	"left": 67,
}

# AnimatableStaticBodies can't move and rotate on the same frame, so alternate each frame
var dumb_fix = 0


func _ready() -> void:
	if player_num == 2:
		rotate_string = "2"
		moving_string = "3"
		target_rotations_dict = {
			"right": 67,
			"left": -67,
		}


func blow_up():
	dead = true
	var particles = CPUParticles3D.new()
	particles.amount = 200
	particles.explosiveness = 1.0
	particles.one_shot = true
	particles.gravity = Vector3(0, -10, 0)
	particles.initial_velocity_min = 10.0
	particles.initial_velocity_max = 20.0
	particles.spread = 180.0
	if player_num == 1:
		particles.color = Color(0, 0.73, 0.32)
	else:
		particles.color = Color(0.89, 0.28, 0.14)
	add_child(particles)
	particles.emitting = true
	backline.visible = false
	frontline.visible = false
	particles.finished.connect(queue_free)
	await particles.finished


func _physics_process(delta: float) -> void:
	if dead:
		return
	if dumb_fix == 0:
		if Input.is_action_pressed(rotate_string):
			current_side = "left"
		else:
			current_side = "right"

		var target_rad = deg_to_rad(target_rotations_dict[current_side])
		var new_rot = lerp_angle(backline.rotation.x, target_rad, min(rotate_speed * delta, 1.0))
		if abs(angle_difference(new_rot, target_rad)) < 0.001:
			new_rot = target_rad
		backline.rotation.x = new_rot
		frontline.rotation.x = new_rot
		dumb_fix = 1
	else:
		var moving = 1 if Input.is_action_pressed(moving_string) else -1
		var temp_move = clamp(backline.position.x + moving * delta * move_speed * backwards, -1, 1)
		backline.position.x = temp_move
		frontline.position.x = temp_move
		dumb_fix = 0
