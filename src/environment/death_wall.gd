extends Area3D


func _on_body_entered(body: Node3D):
	if body.get_meta("type") == "player":
		Global.restart()
