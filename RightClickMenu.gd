extends PopupMenu


signal new_box


func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_PopupMenu_id_pressed(id):
	match id:
		0:
			emit_signal("new_box")
		1:
			$"../Rename".popup()
		2:
			$"../Search".visible = true
