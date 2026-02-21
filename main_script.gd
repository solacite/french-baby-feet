extends Node3D

@onready var UI = get_tree().get_first_node_in_group("UI")

@export var ball_impulse = 0.5

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


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()


func _on_p_1_goal_body_entered(body: Node3D) -> void:
	body.blow_up()
	UI.player_score(1)
	spawn_ball()


func _on_p_2_goal_body_entered(body: Node3D) -> void:
	body.blow_up()
	UI.player_score(2)
	spawn_ball()
