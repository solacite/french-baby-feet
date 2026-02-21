extends Node3D

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
