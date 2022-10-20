extends Control


func _ready():
	$MenuPanel.visible = false


func _on_button_menu_pressed():
	$MenuPanel.visible = !$MenuPanel.visible


func _on_start_button_pressed():
	Global.next_level()
