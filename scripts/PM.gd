
extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	OS.min_window_size = Vector2(1024,600)
	OS.max_window_size = Vector2(1920,1080)
