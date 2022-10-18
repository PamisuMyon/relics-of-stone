extends StaticBody3D

@onready var anim = $Model/AnimationPlayer as AnimationPlayer

func _ready():
	anim.play("Pray")
