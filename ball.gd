extends RigidBody3D

@onready var gpu_particles_3d: CPUParticles3D = $GPUParticles3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func blow_up():
	gpu_particles_3d.emitting = true
	animation_player.play("blow_up_more")


func _physics_process(_delta: float) -> void:
	# if we have a low speed, apply a random impulse only on x/y (not z)
	if linear_velocity.length() < 0.1:
		apply_impulse(Vector3(randf_range(-10, 10), randf_range(-10, 10), 0))
