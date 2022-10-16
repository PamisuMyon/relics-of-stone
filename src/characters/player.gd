extends CharacterBody3D

@export var speed := 5.0
@export var jump_velocity := 4.5
@export var rotation_weight := .5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var model := $Model

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
#	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
#		velocity.y = jump_velocity

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
#	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var target_dir = Vector3(input_dir.x, 0, input_dir.y)
	var direction = (transform.basis * target_dir).normalized()
	if direction:
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
	var target_quat = Basis.looking_at(dir, Vector3.UP).get_rotation_quaternion()
	model.quaternion = model.quaternion.slerp(target_quat, rotation_weight)
