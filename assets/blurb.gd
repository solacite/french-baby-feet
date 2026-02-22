extends Node3D

@export var color: Color


func set_color(coloraaa: Color):
	var materiala = $Cube.get_surface_override_material(0)
	if not materiala:
		materiala = StandardMaterial3D.new()
	materiala.albedo_color = coloraaa
	$Cube.set_surface_override_material(0, materiala)


func _ready() -> void:
	set_color(color)
