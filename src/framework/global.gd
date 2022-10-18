extends Node

var levels = [
	"res://src/levels/test_map.tscn"
]

var current = 0
var current_path = levels[current]

func _physics_process(delta):
	if Input.is_action_just_pressed("restart"):
		restart()


func restart():
	get_tree().change_scene_to_file(current_path)


func next_level():
	current += 1
	if current > levels.size() - 1:
		current = 0
	current_path = levels[current]
	get_tree().change_scene_to_file(current_path)
