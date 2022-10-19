extends CharacterBody3D
class_name Player

const SHAPE_CAST_OFFSET = .416

@export var scroll_count = -1

@export var speed := 5.0
@export var jump_velocity := 4.5
@export var rotation_weight := .5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var move_basis := Basis(Vector3.UP, deg_to_rad(45))
var can_move := true

var dummy_floor_scene = preload("res://src/environment/floor_dummy.tscn")
var dummy_floor: FloorDummy
var is_generating_floor := false

@onready var model = $Model
@onready var ray_cast_ground: RayCast3D = $RayCastGround
@onready var shape_cast_ledge: ShapeCast3D = $ShapeCastLedge
@onready var level = get_parent() as LevelManager

func _physics_process(delta):
	if not can_move:
		return
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var target_dir = Vector3(input_dir.x, 0, input_dir.y)
	var direction = (move_basis * target_dir).normalized()
	
	var is_at_ledge = false
	shape_cast_ledge.position = direction * SHAPE_CAST_OFFSET
	shape_cast_ledge.force_shapecast_update()
	is_at_ledge = not shape_cast_ledge.is_colliding()
	
	if direction and not is_at_ledge:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()
	_smooth_look_at(-target_dir)


func _smooth_look_at(dir: Vector3):
	if dir.is_equal_approx(Vector3.ZERO):
		return
	# smooth look at movement direction
	var target_quat = (move_basis * Basis.looking_at(dir, Vector3.UP)).get_rotation_quaternion()
	model.quaternion = model.quaternion.slerp(target_quat, rotation_weight)


func _process(delta):
	_detect_floor()
	if not is_generating_floor and dummy_floor and dummy_floor.visible and dummy_floor.is_available:
		if Input.is_action_just_pressed("interact"):
			var succeed = level.scroll_change(-1)
			if succeed:
				dummy_floor.toggle_visibility(false)
				_generate_floor(dummy_floor.global_position)


func _detect_floor():
	if is_generating_floor:
		return
	var is_dummy_floor_showed = false
	if ray_cast_ground.is_colliding():
		var col = ray_cast_ground.get_collider()
		if col is Floor:
			var f = col as Floor
			var result = f.get_placeable_floor_position(global_position)
			_show_dummy_floor(result)
			is_dummy_floor_showed = true
			
	if not is_dummy_floor_showed and dummy_floor:
		dummy_floor.toggle_visibility(false)


func _show_dummy_floor(dict: Dictionary):
	if not dummy_floor:
		dummy_floor = dummy_floor_scene.instantiate() as FloorDummy
		get_parent().add_child(dummy_floor)
	dummy_floor.global_position = dict.pos
	if dict.pos == Vector3.ZERO:
		dummy_floor.toggle_visibility(false)
	else:
		dummy_floor.toggle_visibility(true)
		dummy_floor.toggle_availability(dict.can_place)


func _generate_floor(pos: Vector3):
	if is_generating_floor:
		return
	var floor_inst: Floor = preload("res://src/environment/floor.tscn").instantiate()
	get_parent().add_child(floor_inst)
	is_generating_floor = true
	floor_inst.animate_spawn(pos, func(): is_generating_floor = false)


var push_tween: Tween
func pushed(target_pos: Vector3):
	if push_tween:
		push_tween.kill()
	push_tween = create_tween()
	push_tween.set_trans(Tween.TRANS_CUBIC)
	push_tween.set_ease(Tween.EASE_OUT)
	
	can_move = false
	target_pos.y = global_position.y
	push_tween.tween_property(self, "global_position", target_pos, .5)
	await push_tween.finished
	can_move = true
