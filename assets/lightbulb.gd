extends Node3D

var on : bool = false
@onready var lighten_mt = load("res://assets/lighten.tres")
@onready var blank_mt = load("res://assets/blank.tres")

func _process(delta: float) -> void:
	if on:
		$Sphere.set_surface_override_material(0, lighten_mt)
	else:
		$Sphere.set_surface_override_material(0, blank_mt)
		
