extends PopupMenu


signal new_box
signal export_box
signal remove_box
onready var tabs = $"../TabContainer"

func _ready():
	pass


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
		3:
			$"../PartyCreator".showPartyMaker()
		4:
			emit_signal("export_box")
		5:
			var tab = tabs.get_tab_control(tabs.current_tab)
			if tab.isEmpty():
				tabs.remove_child(tab)
				tab.queue_free()
		6:
			$"../Trade".visible = true

func _on_PopupMenu_about_to_show():
	var tab = tabs.get_tab_control(tabs.current_tab)
	if tab != null:
		if tab.isEmpty():
			set_item_disabled(2,false)
		else:
			set_item_disabled(2,true)
