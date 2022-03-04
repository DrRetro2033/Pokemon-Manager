extends TabContainer

onready var box = load("res://Box.tscn")
var page = 0
var max_per_page = 15
var boxes = []
func loadPokemon(bank):
	var overflow = int(bank.data.size() / max_per_page)
	var array = bank.box_names
	print(overflow)
	while overflow >= 0:
		var new_box = box.instance()
		if bank.box_names.size() - 1 >= overflow:
			new_box.name = array.front()
			array.remove(0)
		else:
			new_box.name = "Box%s" % str(get_child_count() + 1)
		boxes.push_back(new_box.name)
		add_child(new_box)
		yield(get_tree().create_timer(1),"timeout")
		overflow -= 1
	print(boxes)
	var current_pos = bank.data
	for x in get_children():
		current_pos = x.setSlots(current_pos)
		yield(get_tree().create_timer(0.1),"timeout")
	$"../Loading Screen".visible = false
	OS.window_resizable = true

func _process(delta):
	if $"../Rename".visible != true or $"../Search".visible != true:
		if Input.is_action_just_pressed("ui_left") and current_tab != 0:
			current_tab -= 1
		elif Input.is_action_just_pressed("ui_right") and current_tab != get_child_count() - 1:
			current_tab += 1
		elif Input.is_action_just_pressed("ui_up"):
			current_tab = 0
		elif Input.is_action_just_pressed("ui_down"):
			current_tab = get_child_count() - 1


func _on_PopupMenu_new_box():
		var new_box = box.instance()
		new_box.name = "Box%s" % str(get_child_count() + 1)
		boxes.push_back(new_box.name)
		print(new_box.name)
		add_child(new_box)

func save(bank):
	bank.box_names = boxes

func _on_Rename_newName(new_name):
	boxes[current_tab] = new_name
	set_tab_title(current_tab,new_name)

func addPokemon(pokemon):
	var overflow = int(pokemon.size() / max_per_page)
	print(overflow)
	while overflow >= 0:
		var new_box = box.instance()
		new_box.name = "Box%s" % str(get_child_count() + 1)
		boxes.push_back(new_box.name)
		add_child(new_box)
		yield(get_tree().create_timer(1),"timeout")
		overflow -= 1
	print(boxes)
	var current_pos = pokemon
	for x in get_children():
		current_pos = x.setSlots(current_pos)
		yield(get_tree().create_timer(0.1),"timeout")
	$"../Loading Screen".visible = false
	OS.window_resizable = true

