extends PopupMenu


signal new_box
signal export_box
signal remove_box
onready var tabs = $"../TabContainer"
var context : Area2D

func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_PopupMenu_id_pressed(id):
	context.item_selected(id)
#	match id:
#		0:
#			emit_signal("new_box")
#		1:
#			$"../Rename".popup()
#		2:
#			$"../Search".visible = true
#		3:
#			$"../PartyCreator".showPartyMaker()
#		4:
#			emit_signal("export_box")
#		5:
#			var tab = tabs.get_tab_control(tabs.current_tab)
#			if tab.isEmpty():
#				tabs.remove_child(tab)
#				tab.queue_free()
#		6:
#			$"../Trade".visible = true
func open_menu(context):
	self.context = context
	clear()
	var items = context.get_items()
	for item in items:
		add_item(item)
	if not items.empty():
		popup()
	else:
		visible = false
