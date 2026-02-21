extends Node3D

@onready var UI = get_tree().get_first_node_in_group("UI")

@onready var camera_pivot: Node3D = $CameraPivot

@export var cam_rotate_speed = 0.5
@export var ball_impulse = 0.5

var cam_direction = 1
# note that at Camera angle at 0 and 180 degrees the players basically reverse

var super_fast_mode = false:
	set(new):
		super_fast_mode = new
		if super_fast_mode:
			Engine.time_scale = 2.5
		else:
			Engine.time_scale = 1.0

const BALL = preload("uid://bbswd1qjburcp")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_ball()


func spawn_ball():
	var ball = BALL.instantiate()
	ball.position = Vector3i(0, 5, -10)
	add_child(ball)
	# yeah there's probably a better notation for this but whatever
	ball.apply_impulse(Vector3(randf_range(-ball_impulse, ball_impulse), randf_range(-ball_impulse, ball_impulse), randf_range(-ball_impulse, ball_impulse)))


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
		
	camera_pivot.rotation.y += cam_rotate_speed * delta * cam_direction

func goal(body: Node3D, player_num: int):
	body.blow_up()
	UI.player_score(player_num)
	spawn_ball()
	cam_direction *= -1
	
	if randi_range(0, 3) == 0: # one in 4 chance
		super_fast_mode = true
	else:
		super_fast_mode = false

func _on_p_1_goal_body_entered(body: Node3D) -> void:
	goal(body, 1)

func _on_p_2_goal_body_entered(body: Node3D) -> void:
	goal(body, 2)
