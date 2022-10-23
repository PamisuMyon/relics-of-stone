extends Node

var levels := [
	"res://src/levels/level_tutorial.tscn",
	"res://src/levels/level_1.tscn",
	"res://src/levels/level_2.tscn",
	"res://src/levels/level_4.tscn",
	"res://src/levels/level_5.tscn",
	"res://src/levels/level_6.tscn",
	"res://src/levels/level_7.tscn",
	"res://src/levels/level_8.tscn",
	"res://src/levels/level_9.tscn",
	"res://src/levels/level_10.tscn",
	"res://src/levels/level_11.tscn",
	"res://src/levels/level_12.tscn",
	"res://src/levels/level_13.tscn",
	"res://src/levels/level_14.tscn",
	"res://src/levels/level_15.tscn",
]

var level_title = "res://src/levels/level_title.tscn"
var level_end = "res://src/levels/level_end.tscn"

var current := -1
var viewing_front := false

func _physics_process(delta):
	if Input.is_action_just_pressed("restart"):
		restart()


func restart():
	if current >= 0 and current < levels.size():
		_change_scene(levels[current])
	else:
		get_tree().reload_current_scene()


func next_level():
	current += 1
	if current >= levels.size():
		current = -1
#		get_tree().change_scene_to_file(level_end)
		_change_scene(level_end)
	else:
#		get_tree().change_scene_to_file(levels[current])
		_change_scene(levels[current])


func select_level(index: int):
	current = clamp(index, 0, levels.size() - 1)
#	get_tree().change_scene_to_file(levels[current])
	_change_scene(levels[current])


func back_to_title():
	current = -1
#	get_tree().change_scene_to_file(level_title)
	_change_scene(level_title)


func _change_scene(path: String):
	var thread := Thread.new()	# TODO pooling?
	thread.start(_do_change_scene.bind(path))


func _do_change_scene(path: String):
	var scene := load(path)
	get_tree().call_deferred("change_scene_to_packed", scene)
