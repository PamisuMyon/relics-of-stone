extends StaticBody3D
class_name Floor

enum Type { NORMAL, PUSH, TELEPORT }

@export var type: Type = Type.NORMAL
@export var push_distance := 0
@export var teleport_target: Node3D

@onready var shape_cast_left: ShapeCast3D = $ShapeCastLeft
@onready var shape_cast_right: ShapeCast3D = $ShapeCastRight
@onready var shape_cast_forward: ShapeCast3D = $ShapeCastForward
@onready var shape_cast_backward: ShapeCast3D = $ShapeCastBackward


func get_placeable_floor_position(player_pos: Vector3) -> Dictionary:
	if type != Type.NORMAL:
		return { "pos": Vector3.ZERO, "can_place": false }
	
	var direction = player_pos - global_position
	var abs_x = abs(direction.x)
	var abs_z = abs(direction.z)
	var shape: ShapeCast3D
	if abs_x > abs_z:
		if direction.x < 0:
			shape = shape_cast_left
		else:
			shape = shape_cast_right
	else:
		if direction.z < 0:
			shape = shape_cast_forward
		else:
			shape = shape_cast_backward
	
	shape.force_shapecast_update()
	if shape.is_colliding():
		for i in shape.get_collision_count():
			var col = shape.get_collider(i)
			if col.collision_layer != 8:	# Layer 4: placeble
				# colliding but not placable area
				return { "pos": Vector3.ZERO, "can_place": false }
		var pos = shape.global_position
		pos.y = global_position.y
		return { "pos": pos, "can_place": true }
	else:
		# empty area
		var pos = shape.global_position
		pos.y = global_position.y
		return { "pos": pos, "can_place": false }


func animate_spawn(pos: Vector3, callback: Callable):
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)
	var final_pos = pos
	pos.y = -26
	global_position = pos
	tween.tween_property(self, "position", final_pos, .7)
	tween.tween_callback(callback)
	$MoveSound.play_random()


func _on_effect_area_body_entered(body: Node3D):
	if body.get_meta("type") == "player":
		var player = body # as Player
		if type == Type.PUSH:
			var target_pos = global_position + -transform.basis.z * push_distance
			player.pushed(target_pos)
			$PushSound.play_random()
		elif type == Type.TELEPORT:
			assert(teleport_target, "no teleport target")
			var target_pos = teleport_target.global_position
			target_pos.y = player.global_position.y
			player.global_position = target_pos
			$PushSound.play_random()
