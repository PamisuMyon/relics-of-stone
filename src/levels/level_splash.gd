extends Control


func _ready():
	$AnimationPlayer.play("loading")
	Global.back_to_title()
