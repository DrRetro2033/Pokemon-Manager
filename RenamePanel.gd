extends PopupDialog


signal newName(new_name)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_Name_text_entered(new_text):
	emit_signal("newName",new_text)
	visible = false
