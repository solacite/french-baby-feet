extends Node3D

@export var backwards = 1
@export var rotate_speed = 5
@export var move_speed = 5
@export var player_num = 1


@onready var backline: Node3D = $Backline
@onready var frontline: Node3D = $Frontline

var rotate_string = "0"
var moving_string = "1"

	# for some really dumb reason, Godot's AnimatableStaticBodies can't move and rotate and the same frame
	# so I'm switching off each frame
var dumb_fix = 0

func _ready() -> void:
	if player_num == 2:
		rotate_string = "2"
		moving_string = "3"

func _physics_process(delta: float) -> void:

	if dumb_fix == 0:
		# rotating
		var direction = 0
		if Input.is_action_pressed(rotate_string):
			direction = 1
		else:
			direction = -1
		
		var temp = rotate_speed * delta * direction * backwards
		
		backline.rotate(Vector3(1,0,0), temp)
		frontline.rotate(Vector3(1,0,0), temp)
		
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
		
		#backline.set_deferred("position.x", temp_move)
		#frontline.set_deferred("position.x", temp_move)
		backline.position.x = clamp(backline.position.x + moving * delta * move_speed * backwards, -1, 1) 
		frontline.position.x = backline.position.x
		dumb_fix = 0
