extends Control

func _ready():
	var button_scene = preload("res://src/ui/level_item_button.tscn")
	var container = $HSplitContainer/LevelSelection/LevelContainer as HFlowContainer
	for i in Global.levels.size():
		var button = button_scene.instantiate()
		container.add_child(button)
		button.text = str(i)
		if Global.current == i:
			button.disabled = true
		button.pressed.connect(_on_level_button_pressed.bind(i))
	
	$HSplitContainer/Menu/Music.set_pressed_no_signal(not AudioServer.is_bus_mute(AudioServer.get_bus_index("Music")))
	$HSplitContainer/Menu/Sound.set_pressed_no_signal(not AudioServer.is_bus_mute(AudioServer.get_bus_index("Sound")))
	$HSplitContainer/Menu/FullScreen.set_pressed_no_signal(DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN)


func _on_level_button_pressed(index: int):
	Global.select_level(index)


func _on_button_resume_pressed():
	visible = false


func _on_button_quit_pressed():
	get_tree().quit()


func _on_full_screen_toggled(button_pressed):
	DisplayServer
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)


func _on_music_toggled(button_pressed):
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), !AudioServer.is_bus_mute(AudioServer.get_bus_index("Music")))


func _on_sound_toggled(button_pressed):
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Sound"), !AudioServer.is_bus_mute(AudioServer.get_bus_index("Sound")))
