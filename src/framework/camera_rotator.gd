extends Node3D

@export var default_speed := 20

var speed

func _ready():
	speed = deg_to_rad(default_speed)

func _process(delta):
	rotate_y(speed * delta)
