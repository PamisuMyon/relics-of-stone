extends AudioStreamPlayer

@export var streams: Array[AudioStream]
@export var play_interval_range := Vector2(20, 30)

var current_index := 0


func _ready():
	stream = streams[current_index]
	play()


func _on_finished():
	await get_tree().create_timer(randf_range(play_interval_range.x, play_interval_range.y)).timeout
	current_index += 1
	current_index %= streams.size()
	stream = streams[current_index]
	play()
