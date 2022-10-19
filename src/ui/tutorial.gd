extends Control

signal next_pressed

var level: LevelManager
var is_content_animating := false

@onready var dialog = $Dialog as Control
@onready var label_dialog = $Dialog/Margin/LabelDialog as RichTextLabel
@onready var label_next = $Dialog/LabelNext as RichTextLabel
@onready var timer = $Timer as Timer


func _ready():
	level = get_parent() as LevelManager
	level.stage_entered.connect(_on_stage_entered)
	dialog.visible = false


func _process(delta):
	if not is_content_animating:
		if Input.is_action_just_pressed("interact"):
			next_pressed.emit()


func _on_stage_entered():
	level.player.can_move = false
	level.witch.anim.play("Idle")
	dialog.visible = true
	for content in dialog_contents:
		label_next.visible = false
		await _anim_show_dialog_content(content)
		label_next.visible = true
		await next_pressed
	dialog.visible = false
	level.player.can_move = true
	level.witch.anim.play("Pray")
	

func _anim_show_dialog_content(content: String):
	label_dialog.text = ""
	is_content_animating = true
	# TODO BBCode compat
	var i = 0
	while i <= content.length():
		if i < content.length() and content[i] == " ":
			i += 1
		label_dialog.text = content.substr(0, i)
		timer.start()
		await timer.timeout
		i += 1
	is_content_animating = false


# hard-code
var dialog_contents = [
	"Hi traveler, are you also trapped in this amazing place? If you can help me with some magical rituals, maybe we can get out of here.",
	"These rituals require some casting materials, see the diamonds over there, I need you to help me collect them.",
	"Here are some scrolls that can summon stone platforms, press the E key on the edge of the platform to use."
]
