extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal item_selected(id)
export var items : Array = []
export var is_active : bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func get_items():
	return items

func item_selected(id):
	emit_signal("item_selected",id)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
