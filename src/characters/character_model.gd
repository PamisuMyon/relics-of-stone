extends Node3D

@onready var character: CharacterBody3D = get_parent()
@onready var anim_tree: AnimationTree = $AnimationTree

func _process(delta):
	if character.velocity.length_squared() < 0.1:
		# idle
		anim_tree.set("parameters/state/transition_request", "idle")
	else:
		# run
		anim_tree.set("parameters/state/transition_request", "run")
