extends AudioStreamPlayer
class_name SoundPlayer

@export var streams: Array[AudioStream]
@export var pitch_range := Vector2(0.8, 1.2)


func play_random():
	stream = streams[randi_range(0, streams.size() - 1)]
	pitch_scale = randf_range(pitch_range.x, pitch_range.y)
	play()
