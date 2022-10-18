extends Node3D
class_name FloorDummy

@export var color_available := Color(.37, .6, .72, .4)
@export var color_unavailable := Color(.72, .37, .37, .4)

@onready var mesh = $RootNode/Floor_SquareLarge as MeshInstance3D

var is_available := false

func toggle_availability(available: bool):
	is_available = available
	var mat = mesh.get_active_material(0) as BaseMaterial3D
	if available:
		mat.albedo_color = color_available
	else:
		mat.albedo_color = color_unavailable


func toggle_visibility(is_visible: bool):
	visible = is_visible
