extends AudioStreamPlayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func fade_background_music_out(speed:float):
	while volume_db > -120:
		volume_db -= 0.1
		yield(get_tree().create_timer(speed/1000),"timeout")
	stop()

func fade_background_music_in(speed:float):
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
