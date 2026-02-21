extends Node3D

@export var backwards = 1
@export var rotate_speed = 30
@export var move_speed = 20
@export var player_num = 1


@onready var backline: Node3D = $Backline
@onready var frontline: Node3D = $Frontline

var rotate_string = "0"
var moving_string = "1"

var current_side = "right" # can be "left"
var target_rotations_dict = {
	"right": -67,
	"left": 67,
}

	# for some really dumb reason, Godot's AnimatableStaticBodies can't move and rotate and the same frame
	# so I'm switching off each frame
var dumb_fix = 0

func _ready() -> void:
	if player_num == 2:
		rotate_string = "2"
		moving_string = "3"
		target_rotations_dict = {
			"right": 67,
			"left": -67,
		}

func _physics_process(delta: float) -> void:

	if dumb_fix == 0:
		# define the current side
		
		if Input.is_action_pressed(rotate_string):
			current_side = "left"
		else:
			current_side = "right"
		
		# rotating
	
		var target_rotation = target_rotations_dict[current_side]
		var target_rad = deg_to_rad(target_rotation)
		var new_rot = lerp_angle(backline.rotation.x, target_rad, rotate_speed * delta)
		backline.rotation.x = new_rot
		frontline.rotation.x = new_rot
		
		#backline.rotation.x += rotate_speed * delta * direction * backwards
		#frontline.rotation.x = backline.rotation.x
		dumb_fix = 1
	else:
		
		# moving left and right
		var moving = 0
		if Input.is_action_pressed(moving_string):
			moving = 1
		else:
			moving = -1
		
		var temp_move = clamp(backline.position.x + moving * delta * move_speed * backwards, -1, 1)
		
		backline.position.x = temp_move
		frontline.position.x = backline.position.x
		dumb_fix = 0
