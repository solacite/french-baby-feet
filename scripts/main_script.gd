extends Node3D

@onready var UI = get_parent()
@onready var initial_lights: Node3D = $InitialLights
@onready var camera_animate: AnimationPlayer = $Cameras/CameraAnimate
@onready var pivot: Node3D = $Cameras
@onready var menu = $"../menu"

@export var ball_impulse = 0.5

var started = false
var current_ball: Node3D = null
var pressed_button = [false, false, false, false]

var super_fast_mode = false:
	set(new):
		super_fast_mode = new
		Engine.time_scale = 1.5 if super_fast_mode else 1.0

const BALL = preload("res://scenes/ball.tscn")


func spawn_ball():
	var ball = BALL.instantiate()
	ball.position = Vector3i(0, 5, -10)
	add_child(ball)
	current_ball = ball
	ball.apply_impulse(
		Vector3(
			randf_range(-ball_impulse, ball_impulse),
			randf_range(-ball_impulse, ball_impulse),
			randf_range(-ball_impulse, ball_impulse)
		)
	)


func _process(delta: float) -> void:
	if started and current_ball and is_instance_valid(current_ball) and menu.is_pause:
		pivot.position.z = lerp(pivot.position.z, current_ball.position.z + 12, 5.0 * delta)


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()

	if not started:
		print("checking buttons")
		for i in range(4):
			print("checking button ", i)
			if event.is_action_pressed(str(i)):
				print("button ", i, " pressed")
				pressed_button[i] = true
				var bulb = initial_lights.get_child(i + 1)
				bulb.on = true
		if pressed_button.all(func(b): return b):
			print("all buttons pressed, starting game")
			started = true
			initial_lights.get_child(0).play("fly_away")
			UI.animation_player.play("start_game")
			camera_animate.play("start_camera")


func camera_spin_and_spawn():
	var tween = create_tween()
	(
		tween
		. tween_property(pivot, "rotation:y", TAU, 2)
		. as_relative()
		. set_ease(Tween.EASE_IN_OUT)
		. set_trans(Tween.TRANS_CUBIC)
	)
	tween.tween_callback(spawn_ball)


func goal(body: Node3D, player_num: int):
	body.blow_up()
	UI.player_score(player_num)
	super_fast_mode = randi_range(0, 3) == 0
	camera_spin_and_spawn()


func _on_p_1_goal_body_entered(body: Node3D) -> void:
	goal(body, 1)


func _on_p_2_goal_body_entered(body: Node3D) -> void:
	goal(body, 2)


func _on_out_of_bounds_body_entered(body: Node3D) -> void:
	body.queue_free()
	spawn_ball()
