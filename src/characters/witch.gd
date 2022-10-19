extends StaticBody3D

@export var default_anim = "Pray"
@onready var anim = $Model/AnimationPlayer as AnimationPlayer

func _ready():
	anim.play(default_anim)
