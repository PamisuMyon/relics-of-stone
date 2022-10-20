extends Node

var levels := [
	"res://src/levels/level_tutorial.tscn",
	"res://src/levels/level_1.tscn",
	"res://src/levels/level_2.tscn",
	"res://src/levels/level_3.tscn",
	"res://src/levels/level_4.tscn",
	"res://src/levels/level_5.tscn",
	"res://src/levels/level_6.tscn",
	"res://src/levels/level_7.tscn",
	"res://src/levels/level_8.tscn",
	"res://src/levels/level_9.tscn",
	"res://src/levels/level_10.tscn",
]

var level_title = "res://src/levels/level_title.tscn"

var current := -1

func _physics_process(delta):
	if Input.is_action_just_pressed("restart"):
		restart()


func restart():
#	get_tree().change_scene_to_file(current_path)
	get_tree().reload_current_scene()


func next_level():
	current += 1
	if current > levels.size() - 1:
		current = 0
	get_tree().change_scene_to_file(levels[current])


func select_level(index: int):
	current = clamp(index, 0, levels.size() - 1)
	get_tree().change_scene_to_file(levels[current])


func back_to_title():
	current = -1
	get_tree().change_scene_to_file(level_title)
