extends RigidBody3D

@onready var gpu_particles_3d: CPUParticles3D = $GPUParticles3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func blow_up():
	gpu_particles_3d.emitting = true
	animation_player.play("blow_up_more")
	
