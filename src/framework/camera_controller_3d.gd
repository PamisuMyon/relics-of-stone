extends Node3D
class_name CameraController3D

@export var target: Node3D

var tracking = true


func _ready():
	global_position = target.global_position


func _process(delta):
	if tracking:
		global_position = target.global_position
