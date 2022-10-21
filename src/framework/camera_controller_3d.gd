extends Node3D
class_name CameraController3D

@export var target: Node3D
@export var zoom_range := Vector2(15, 35)
@export var zoom_speed := .5
@export var drag_threshold_squared := 100
@export var drag_speed := 42

var tracking := true
var dragging := false

@onready var camera = $Camera3D as Camera3D

func _ready():
	global_position = target.global_position


func _process(delta):
	if not tracking:
		return
	
	if dragging:
		global_position = global_position.move_toward(target.global_position, drag_speed * delta)
		if global_position.is_equal_approx(target.global_position):
			dragging = false
	else:
		var dir = target.global_position - global_position
		if dir.length_squared() > drag_threshold_squared:
			dragging = true
		else:
			global_position = target.global_position

	
	var zoom_distance = 0
	if Input.is_action_pressed("zoom_in"):
		zoom_distance = -zoom_speed
	elif Input.is_action_pressed("zoom_out"):
		zoom_distance = zoom_speed
	if zoom_distance != 0:
		var pos = camera.position
		pos.z += zoom_distance
		pos.z = clampf(pos.z, zoom_range.x, zoom_range.y)
		camera.position = pos
