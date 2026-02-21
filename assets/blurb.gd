extends Node3D

@export var color : Color

func _ready() -> void:
	var materiala = $Cube.get_surface_override_material(0)
	if not materiala:
		materiala = StandardMaterial3D.new()
	materiala.albedo_color = color
	$Cube.set_surface_override_material(0, materiala)
