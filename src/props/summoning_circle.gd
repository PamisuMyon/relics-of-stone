extends MeshInstance3D
class_name SummoningCircle

signal activate_finished


func _ready():
	$AnimationPlayer.play("normal")


func activate():
	$AnimationPlayer.play("activate")


# call from animation
func on_activate_anim_finished():
	activate_finished.emit()
