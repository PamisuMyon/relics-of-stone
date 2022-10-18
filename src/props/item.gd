extends Area3D

enum ItemType { KEY, SCROLL }

@export var type: ItemType = ItemType.KEY

var is_valid = true

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
	# Get Witch position
	var witch := get_node("../Witch") as Node3D
	assert(witch, "Scene must contains a witch")
	
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)
	
	# anim up
	var target_pos_1 = global_position
	target_pos_1.y += 5
	tween.tween_property(self, "global_position", target_pos_1, .5)
	tween.tween_interval(.2)
	
	# anim to witch
	tween.set_parallel(true)
	var target_pos_2 = witch.global_position
	tween.tween_property(self, "global_position", target_pos_2, .5)
	tween.tween_interval(.3)
	tween.chain().tween_property(self, "scale", Vector3.ZERO, .2)
	
	await tween.finished
	# TODO key + 1


func _anim_scroll_collected():
	# Get Player position
	var player := get_node("../Player") as Node3D
	
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)
	
	# anim up
	var target_pos_1 = global_position
	target_pos_1.y += 2
	tween.tween_property(self, "global_position", target_pos_1, .5)
	tween.tween_interval(.2)
	
	# anim to player
	tween.set_parallel(true)
	var target_pos_2 = player.global_position
	tween.tween_property(self, "global_position", target_pos_2, .5)
	tween.tween_interval(.3)
	tween.chain().tween_property(self, "scale", Vector3.ZERO, .2)
	
	await tween.finished
	# TODO scroll + 1
