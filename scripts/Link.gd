extends LinkButton


# This is a Script that just for creating weblinks that open in the user's webbrowser

class_name Link

export var link = ""
func _ready():
	connect("pressed",self,"on_pressed")

func on_pressed():
	OS.shell_open(link)
