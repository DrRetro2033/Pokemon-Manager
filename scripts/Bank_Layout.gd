extends TabContainer

onready var box = load("res://scenes/Box.tscn")
var page = 0
var max_per_page = 24
var boxes = {}
func loadPokemon(bank):
	var overflow = int(bank.data.size() / max_per_page)
	var array = bank.boxes.keys()
	print(overflow)
	while array.size() > 0: #if there are more pokemon that can't all fit into one box it creates new ones
		var new_box = box.instance()
		new_box.name = array.front()
		array.remove(0)
#		if bank.box_names.size() - 1 >= overflow:
#			new_box.name = array.front()
#			array.remove(0)
#		else:
#			new_box.name = "Box%s" % str(get_child_count() + 1)
#			boxes.push_back(new_box.name)
		add_child(new_box)
		yield(get_tree().create_timer(0.01),"timeout")
#		overflow -= 1
	print(boxes)
	boxes = bank.boxes
	for x in get_children():
		x.setSlots(boxes[x.name])
		yield(get_tree().create_timer(0.01),"timeout")
	for x in get_children():
		if x.isEmpty():
			remove_child(x)
			x.queue_free()
	$"../Loading Screen".finised()

func _process(delta):
	if !Trainer.first_time_setup:
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
		var count = 1
		while true:
			var exists = false
			for child in get_children():
				if child.name == "Box%s" % str(get_child_count() + count):
					exists = true
					break
			if not exists:
				break
			count += 1
		new_box.name = "Box%s" % str(get_child_count() + count)
		print(new_box.name)
		add_child(new_box)

func save(bank):
	var pos = 0
	while pos <= get_tab_count()-1:
		if not get_tab_control(pos).isEmpty():
			boxes[get_tab_control(pos).name] = get_tab_control(pos).list_pokemon()
		pos += 1
	bank.boxes = boxes

func _on_Rename_newName(new_name):
	get_tab_control(current_tab).name = new_name
	set_tab_title(current_tab,new_name)

func addPokemon(pokemon,bank):
	var array = bank.boxes.keys()
	print(pokemon)
	if array.size() > 0:
		while array.size() > 0: #if there are more pokemon that can't all fit into one box it creates new ones
			var new_box = box.instance()
			new_box.name = array.front()
			array.remove(0)
			add_child(new_box)
			yield(get_tree().create_timer(0.01),"timeout")
#		print(boxes)
		for child in get_children():
			child.setSlots(bank.boxes[child.name])
			yield(get_tree().create_timer(0.01),"timeout")
		for x in pokemon:
			var space_exists = false
			for child in get_children():
				if not child.isFull():
					child.setEmpty(x)
					space_exists = true
					break
			if not space_exists:
				break
			pokemon.erase(x)
	elif not pokemon.empty():
		var overflow = int(pokemon.size() / max_per_page)
#		print(overflow)
		while overflow >= 0: 
			var new_box = box.instance()
			new_box.name = "Box%s" % str(get_child_count() + 1)
			add_child(new_box)
			yield(get_tree().create_timer(1),"timeout")
			overflow -= 1
		var current_pos = pokemon
		for x in get_children():
			if x.isEmpty():
				current_pos = x.setSlots(current_pos)
				yield(get_tree().create_timer(0.01),"timeout")
	for x in get_children():
		if x.isEmpty():
			remove_child(x)
			x.queue_free()
	$"../Loading Screen".finised()

func _on_PopupMenu_export_box():
	var box = get_tab_control(current_tab)
	var export_box = box.list_pokemon()
	var box_to_showdown = ""
	for id in export_box:
		if id == null:
			continue
		else:
			box_to_showdown += PokemonShowdown.export_to_showdown(Pokemon.pokemon[id])
	OS.clipboard = box_to_showdown
	$"../Copied".popup()
