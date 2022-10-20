extends Control

var level: LevelManager
@onready var label_key = $BoxKey/LabelKey as Label
@onready var label_scroll = $BoxScroll/LabelScroll as Label
@onready var anim = $AnimationPlayer as AnimationPlayer

func _ready():
	level = get_parent() as LevelManager
	level.key_changed.connect(_on_key_changed)
	level.scroll_changed.connect(_on_scroll_changed)
	level.scroll_change_failed.connect(_on_scroll_change_failed)
	$MenuPanel.visible = false


func _on_key_changed(new_value: int, target: int):
	label_key.text = "%d / %d" % [new_value, target]
	anim.play("key_change")


func _on_scroll_changed(new_value: int):
	if new_value == -1:
		label_scroll.text = "-"
	else:
		label_scroll.text = str(new_value)
	anim.play("scroll_change")


func _on_scroll_change_failed():
	anim.play("scroll_change_fail")


func _on_button_restart_pressed():
	Global.restart()


func _on_button_menu_pressed():
	$MenuPanel.visible = !$MenuPanel.visible
