extends WindowDialog


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
class_name Window
signal minmize(window)

func minmize():
	emit_signal("minmize",self)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
