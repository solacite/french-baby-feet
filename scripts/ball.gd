extends RigidBody3D

@onready var gpu_particles_3d: CPUParticles3D = $GPUParticles3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	var gradient := Gradient.new()
	var hue := randf()
	gradient.set_color(0, Color.from_hsv(hue, 0.8, 1.0))
	gradient.set_color(1, Color.from_hsv(fmod(hue + 0.3, 1.0), 0.9, 1.0))
	gpu_particles_3d.color_initial_ramp = gradient

func blow_up():
	gpu_particles_3d.emitting = true
	animation_player.play("blow_up_more")

func _physics_process(_delta: float) -> void:
	# if we have a low speed, apply a random impulse only on x/z (not y)
	if linear_velocity.length() < 0.5:
		apply_impulse(Vector3(randf_range(-10, 10), 0, randf_range(-10, 10)))

func _on_gpu_particles_3d_finished() -> void:
	self.queue_free()
