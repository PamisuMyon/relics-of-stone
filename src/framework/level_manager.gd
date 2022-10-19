extends Node
class_name LevelManager

signal scroll_changed(new_value: int)
signal scroll_change_failed
signal key_changed(new_value: int, target: int)
signal stage_entered

@export var initial_scroll_count := -1
@export var target_key_count := 1
var scroll_count := -1
var key_count := 0

var player: Player
var witch: Node3D
var camera_controller: CameraController3D


func _ready():
	player = $Player as Player
	assert(player, "Scene must contains a player")
	
	witch = $Witch as Node3D
	assert(witch, "Scene must contains a witch")
	
	camera_controller = $CameraController as CameraController3D
	assert(witch, "Scene must contains a camera controller")
	
	enter_stage()
	
	await get_tree().create_timer(.2).timeout
	scroll_count = initial_scroll_count
	scroll_changed.emit(scroll_count)
	key_changed.emit(key_count, target_key_count)


func enter_stage():
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)
	tween.set_parallel(true)
	
	var player_pos = player.global_position
	var player_target_pos = player_pos
	player_pos.y = 20
	player.global_position = player_pos
	player.can_move = false
	camera_controller.tracking = false
	tween.tween_property(player, "global_position", player_target_pos, 1)
	
	var witch_pos = witch.global_position
	var witch_target_pos = witch_pos
	witch_pos.y = 20
	witch.global_position = witch_pos
	tween.tween_property(witch, "global_position", witch_target_pos, 1)
	
	await tween.finished
	player.can_move = true
	camera_controller.tracking = true
	stage_entered.emit()


func exit_stage():
	var circle = $SummoningCircle as SummoningCircle
	circle.activate()
	await circle.activate_finished
	
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)
	tween.set_parallel(true)
	
	var player_target_pos = player.global_position
	player_target_pos.y = 20
	player.can_move = false
	camera_controller.tracking = false
	tween.tween_property(player, "global_position", player_target_pos, 1)
	
	var witch_target_pos = witch.global_position
	witch_target_pos.y = 20
	tween.tween_property(witch, "global_position", witch_target_pos, 1)
	
	await tween.finished
	Global.next_level()


func key_change(delta: int):
	key_count += delta
	key_changed.emit(key_count, target_key_count)
	if key_count == target_key_count:
		exit_stage()


func scroll_change(delta: int) -> bool:
	if delta < 0 and scroll_count != -1 and scroll_count <= 0:
		# failed
		scroll_change_failed.emit()
		return false
	
	if scroll_count != -1:
		scroll_count += delta
	scroll_changed.emit(scroll_count)
	return true
