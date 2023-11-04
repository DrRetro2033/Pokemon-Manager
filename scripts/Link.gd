extends LinkButton


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

class_name Link
# Called when the node enters the scene tree for the first time.
export var link = ""
func _ready():
	connect("pressed",self,"on_pressed")

func on_pressed():
	OS.shell_open(link)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
