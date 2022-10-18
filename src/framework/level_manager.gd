extends Node
class_name LevelManager

signal scroll_changed(new_value: int)
signal scroll_change_failed
signal key_changed(new_value: int, target: int)

@export var initial_scroll_count := -1
@export var target_key_count := 1
var scroll_count := -1;
var key_count := 0;

var player: Player
var witch: Node3D


func _ready():
	player = $Player as Player
	assert(player, "Scene must contains a player")
	
	witch = $Witch as Node3D
	assert(witch, "Scene must contains a witch")
	
	await create_tween().tween_interval(.2).finished
	scroll_count = initial_scroll_count
	scroll_changed.emit(scroll_count)
	key_changed.emit(key_count, target_key_count)


func key_change(delta: int):
	key_count += delta
	key_changed.emit(key_count, target_key_count)


func scroll_change(delta: int) -> bool:
	if delta < 0 and scroll_count != -1 and scroll_count <= 0:
		# failed
		scroll_change_failed.emit()
		return false
	
	if scroll_count != -1:
		scroll_count += delta
	scroll_changed.emit(scroll_count)
	return true
