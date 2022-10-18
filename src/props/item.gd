extends Area3D

enum ItemType { KEY, SCROLL }

@export var type: ItemType = ItemType.KEY

var is_valid = true

var rotate_speed: Vector3

func _ready():
	rotate_speed = Vector3(randf_range(-1, 1), randf_range(-1, 1), randf_range(-1, 1))


func _process(delta):
#	var trans = transform.rotated(transform., rotate_speed.x * delta)
#	trans = trans.rotated(Vector3.UP, rotate_speed.y * delta)
#	trans = trans.rotated(Vector3.FORWARD, rotate_speed.z * delta)
	rotate_x(rotate_speed.x * delta)
	rotate_y(rotate_speed.y * delta)
	rotate_z(rotate_speed.z * delta)


func _on_body_entered(body):
	if not is_valid:
		return
	if type == ItemType.KEY:
		is_valid = false
		_anim_key_collected()
	elif type == ItemType.SCROLL:
		is_valid = false
		_anim_scroll_collected()


func _anim_key_collected():
	var level = get_parent() as LevelManager
	
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)
	
	# anim up
	var target_pos_1 = global_position
	target_pos_1.y += 5
	tween.tween_property(self, "global_position", target_pos_1, .4)
	tween.tween_interval(.2)
	
	# anim to witch
	tween.set_parallel(true)
	var target_pos_2 = level.witch.global_position
	tween.tween_property(self, "global_position", target_pos_2, .5)
	tween.tween_property(self, "scale", Vector3(.1, .1, .1), .5)
	
	await tween.finished
	# key + 1
	level.key_change(1)


func _anim_scroll_collected():
	var level = get_parent() as LevelManager
	
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)
	
	# anim up
	var target_pos_1 = global_position
	target_pos_1.y += 2
	tween.tween_property(self, "global_position", target_pos_1, .4)
	tween.tween_interval(.2)
	
	# anim to player
	tween.set_parallel(true)
	var target_pos_2 = level.player.global_position
	tween.tween_property(self, "global_position", target_pos_2, .2)
	tween.tween_property(self, "scale", Vector3(.01, .01, .01), .2)
	
	await tween.finished
	# scroll + 1
	level.scroll_change(1)
