extends Node3D

@onready var UI = get_tree().get_first_node_in_group("UI")

@onready var cameras: Node3D = $Cameras
@onready var follow_ball_cam: Camera3D = $Cameras/FollowPoint/FollowBallCam
@onready var camera_pivot = $Cameras/FollowPoint

@export var cam_rotate_speed = 0.5
@export var ball_impulse = 0.5
var player_score: int = 0

var cam_direction = 1
# note that at Camera angle at 0 and 180 degrees the players basically reverse

var super_fast_mode = false:
	set(new):
		super_fast_mode = new
		if super_fast_mode:
			Engine.time_scale = 2.5
		else:
			Engine.time_scale = 1.0

var current_ball: Node3D = null
const BALL = preload("res://ball.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_ball()


func spawn_ball():
	var ball = BALL.instantiate()
	ball.position = Vector3i(0, 5, -10)
	add_child(ball)
	current_ball = ball

	# tween to the next ball position
	#var tween = create_tween()
	#tween.tween_property(follow_ball_cam, "position.z", -10, 0.5)
	#follow_ball_cam.position.x
	# yeah there's probably a better notation for this but whatever
	ball.apply_impulse(
		Vector3(
			randf_range(-ball_impulse, ball_impulse),
			randf_range(-ball_impulse, ball_impulse),
			randf_range(-ball_impulse, ball_impulse)
		)
	)


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()


#func _input(_event: InputEvent) -> void:

#if Input.is_action_just_pressed()


func goal(body: Node3D, player_num: int):
	body.blow_up()
	spawn_ball()
	cam_direction *= -1

	if randi_range(0, 3) == 0:  # one in 4 chance
		super_fast_mode = true
	else:
		super_fast_mode = false


func _on_p_1_goal_body_entered(body: Node3D) -> void:
	goal(body, 1)


func _on_p_2_goal_body_entered(body: Node3D) -> void:
	goal(body, 2)
