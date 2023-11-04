extends TabContainer

onready var box = load("res://scenes/Box.tscn")
var page = 0
var max_per_page = 24
var boxes = {}

func _ready():
	pass

func loadPokemon(bank):
	var boxes = bank.boxes
	yield(get_tree().create_timer(0.1),"timeout")
	print(boxes)
	for n in boxes.keys():
		var new_box = box.instance()
		new_box.name = n
		add_child(new_box,true)
		new_box.setSlots(boxes[n])
		$"../Tabs".add_tab(n)
	$"../Loading Screen".finised()

func _process(delta):
#	if !Trainer.first_time_setup and not get_focus_owner() is TextEdit:
#		if Input.is_action_just_pressed("ui_left") and current_tab != 0:
#			current_tab -= 1
#		elif Input.is_action_just_pressed("ui_right") and current_tab != get_child_count() - 1:
#			current_tab += 1
#		elif Input.is_action_just_pressed("ui_up"):
#			current_tab = 0
#		elif Input.is_action_just_pressed("ui_down"):
#			current_tab = get_child_count() - 1
	pass


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
	for child in get_children():
		bank.boxes[child.name] = child.get_slots()

func _on_Rename_newName(new_name):
	get_tab_control(current_tab).name = new_name
	set_tab_title(current_tab,new_name)

func addPokemon(pokemon):
	print(pokemon)
	var current_box = null
	while true:
		if get_child_count() == 0:
			var new_box = box.instance()
			new_box.name = "Box%s" % str(get_child_count() + 1)
			add_child(new_box)
			current_box = new_box
		elif current_box == null:
			for child in get_children():
				if not child.isFull():
					current_box = child
					break
			if current_box == null:
				var new_box = box.instance()
				new_box.name = "Box%s" % str(get_child_count() + 1)
				add_child(new_box)
				current_box = new_box
		for x in pokemon:
			if not current_box.isFull():
				current_box.setEmpty(x)
			else:
				current_box = null
				break
			pokemon.erase(x)
		if pokemon.empty():
			break
		yield(get_tree().create_timer(0.001),"timeout")
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


func _on_Tabs_tab_changed(tab):
	current_tab = tab


func _on_Tabs_drag_switch_tab(tab):
	current_tab = tab
