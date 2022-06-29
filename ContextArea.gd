extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal contextMenu(context)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func contextMenu(area):
	emit_signal("contextMenu",area)
