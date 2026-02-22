extends Node3D

@onready var UI = get_parent()
@onready var initial_lights: Node3D = $InitialLights
@onready var camera_animate: AnimationPlayer = $Cameras/CameraAnimate
@onready var pivot: Node3D = $Cameras/pivot
@onready var menu = $"../menu"
var spinning: bool = false
var winning: bool = false
var winning_player: int = 0
var winning_camera_started: bool = false
@export var ball_impulse = 0.5

var started = false
var current_ball: Node3D = null
var pressed_button = [false, false, false, false]

@onready var p1: Node3D = $P1
@onready var p2: Node3D = $P2

var super_fast_mode = false:
	set(new):
		super_fast_mode = new
		Engine.time_scale = 1.5 if super_fast_mode else 1.0

const BALL = preload("res://scenes/ball.tscn")


func _ready() -> void:
	var sky_material = $WorldEnvironment.environment.sky.sky_material
	if sky_material is PanoramaSkyMaterial:
		sky_material.energy_multiplier = 0.0


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
	if started and menu.is_pause == false and pivot and current_ball and not winning:
		if not spinning:
			pivot.position.z = lerp(pivot.position.z, current_ball.position.z + 12, 5.0 * delta)
		if spinning:
			# put the .z at the spawn position
			pivot.position.z = lerp(pivot.position.z, -0.0, 5.0 * delta)
	if winning and not winning_camera_started:
		winning_camera_started = true
		$Cameras/CameraAnimate.play("winning_camera")


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("reset") and winning:
		get_tree().reload_current_scene()

	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()

	if not started:
		for i in range(4):
			if event.is_action_pressed(str(i)):
				pressed_button[i] = true
				var bulb = initial_lights.get_child(i + 1)
				bulb.on = true
				$CLICK.play()
		if pressed_button.all(func(b): return b):
			started = true
			initial_lights.get_child(0).play("fly_away")
			UI.animation_player.play("start_game")
			camera_animate.play("start_camera")
			$MUSIC.play()


func camera_spin_and_spawn():
	if not winning:
		spinning = true
		var tween = create_tween()
		(
			tween
			. tween_property(pivot, "rotation:y", TAU, 2)
			. as_relative()
			. set_ease(Tween.EASE_IN_OUT)
			. set_trans(Tween.TRANS_CUBIC)
		)
		tween.tween_callback(
			func():
				spinning = false
				spawn_ball()
		)


func goal(body: Node3D, player_num: int):
	var anim_name: String
	if player_num == 1:
		anim_name = "blue_goal"
	else:
		anim_name = "red_goal"

	$CanvasLayer/GOALIDK.play(anim_name)

	$GOAL.play()
	body.blow_up()
	UI.player_score(player_num)
	if UI.game_over:
		var loser = p1 if player_num == 1 else p2
		loser.blow_up()
		pivot.rotation.y = fmod(pivot.rotation.y, TAU)
		pivot.position = Vector3.ZERO
	else:
		camera_spin_and_spawn()


func _on_p_1_goal_body_entered(body: Node3D) -> void:
	goal(body, 1)


func _on_p_2_goal_body_entered(body: Node3D) -> void:
	goal(body, 2)


func _on_out_of_bounds_body_entered(body: Node3D) -> void:
	$BOO.play()
	body.queue_free()
	spawn_ball()


func blow_up_non_winning_player():
	var winner_color: Color = Color("3aa0fc")
	var player_name_human_readable : String
	if winning_player == 2:
		winner_color = Color("e34823")
		player_name_human_readable = "blue"
		if winning_player == 2:
			player_name_human_readable = "red"
	
	else:
		p1.blow_up()
	
	$Control/Label.text = "Player %d \n Wins!!" % winning_player
	$blurb.set_color(winner_color)
	var stylebox = StyleBoxFlat.new()
	stylebox.bg_color = winner_color
	$Control/WinnerPanel.add_theme_stylebox_override("panel", stylebox)
	$AnimationPlayer.play("winning_screen")
