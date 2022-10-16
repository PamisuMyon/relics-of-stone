extends Node3D

@onready var character: CharacterBody3D = get_parent()
@onready var anim_tree: AnimationTree = $AnimationTree

func _process(delta):
	if character.velocity.length_squared() < 0.1:
		anim_tree["parameters/state/current"] = 0
	else:
		anim_tree["parameters/state/current"] = 1
