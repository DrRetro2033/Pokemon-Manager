extends WindowDialog


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var search_bar = $Panel/VBoxContainer/PanelContainer/VBoxContainer/HFlowContainer/LineEdit
var item = load("res://scenes/AutoCompleteItem.tscn")
var tag_instance = load("res://scenes/Tag.tscn")
var button = load("res://scenes/Pokemon_Button.tscn")
var last_text = ""
var tags = []
# Called when the node enters the scene tree for the first time.
func _ready():
	for child in search_bar.get_children():
		if child is VScrollBar:
			search_bar.remove_child(child)
		elif child is HScrollBar:
			search_bar.remove_child(child)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_down"):
		if search_bar.has_focus() and search_bar.get_child_count() > 0:
			$PopupPanel/ScrollContainer/VBoxContainer.get_child(0).grab_focus()
	elif Input.is_action_just_pressed("ui_accept"):
		if search_bar.has_focus():
			on_auto_complete_selected($PopupPanel/ScrollContainer/VBoxContainer.get_child(0))

func auto_complete_list(text:String):
	var matches = []
	var array = Pokemon.types.keys()
	array.erase("NULL")
	var x = 0
	while x < array.size():
		array[x] = "type:"+array[x]
		x += 1
	if not has_reach_limit_of_tag_type(array,2):
		for key in array: #Search for types.
			if key.to_lower().split(':')[1].begins_with(text.to_lower()):
				if not tags.has(key):
					matches.append(key)
	var trainers = []
	for train in Trainer.trainers:
		trainers.append('trainer:'+train.nickname)
	if not has_reach_limit_of_tag_type(trainers,1):
		for train in Trainer.trainers:
			if str(train.nickname).to_lower().begins_with(text.to_lower()):
				var str_1 = 'trainer:'+train.nickname+','+str(train.id)+','+str(train.gender)+','+str(train.game)
				matches.append(str_1)
				print(train.nickname)
	var genders = ["gender:0","gender:1","gender:2"]
	if not has_reach_limit_of_tag_type(genders,1):
		if "Male".begins_with(text.capitalize()):
			matches.append("gender:0")
		elif "Female".begins_with(text.capitalize()):
			matches.append("gender:1")
		elif "Nonbinary".begins_with(text.capitalize()):
			matches.append("gender:2")
	return matches

func has_reach_limit_of_tag_type(types_of_tags:Array,limit:int):
	var count = 0
	for tag in tags:
		if types_of_tags.has(tag):
			count += 1
	if count >= limit:
		return true
	return false

func show_tags():
	for child in $Panel/VBoxContainer/PanelContainer/VBoxContainer/ScrollContainer/HBoxContainer.get_children():
		if child is Tag:
			$Panel/VBoxContainer/PanelContainer/VBoxContainer/ScrollContainer/HBoxContainer.remove_child(child)
	
	for tag in tags:
		var node = tag_instance.instance()
		$Panel/VBoxContainer/PanelContainer/VBoxContainer/ScrollContainer/HBoxContainer.add_child(node)
		node.set_tag(tag)
		node.connect("delete_tag",self,"delete_tag")

func show_auto_complete(array:Array):
	for child in $PopupPanel/ScrollContainer/VBoxContainer.get_children():
		if child is AutoCompleteItem:
			$PopupPanel/ScrollContainer/VBoxContainer.remove_child(child)
	for x in array:
		var node : Button = item.instance()
		$PopupPanel/ScrollContainer/VBoxContainer.add_child(node)
		node.set_item(x)
		node.connect("pressed",self,"on_auto_complete_selected",[node])
	search_bar.update()
	search_bar.set_focus_neighbour(MARGIN_BOTTOM,$PopupPanel/ScrollContainer/VBoxContainer.get_child(0).get_path())
	$PopupPanel/ScrollContainer/VBoxContainer.get_child(0).set_focus_neighbour(MARGIN_TOP,search_bar.get_path())

func delete_tag(tag:String):
	tags.erase(tag)
	show_tags()
	showResults(Pokemon.tag_search(tags))

func auto_complete():
	var column = search_bar.cursor_get_column()
	if last_text.length() > search_bar.text.length():
		pass
	else:
		column -= 1
	if search_bar.text.length() <= 0:
		$PopupPanel.visible = false
		return
	var pos = search_bar.get_pos_at_line_column(0,column)
	last_text = search_bar.text
	print(pos)
	print(search_bar.cursor_get_column())
	var array = auto_complete_list(search_bar.text)
	if array.empty():
		$PopupPanel.visible = false
		return
	show_auto_complete(array)
	pos += search_bar.rect_global_position
	$PopupPanel.popup(Rect2(pos,$PopupPanel.rect_size))
	search_bar.grab_focus()

func on_auto_complete_selected(node):
	if Input.is_key_pressed(KEY_SHIFT):
		tags.append(search_bar.text)
	else:
		tags.append(node.item)
	show_tags()
	search_bar.text = ""
	auto_complete()
	showResults(Pokemon.tag_search(tags))

func text_changed():
	if search_bar.get_line_count() > 1:
		search_bar.undo()
	auto_complete()

func showResults(database):
	for child in $Panel/VBoxContainer/ScrollContainer/VBoxContainer.get_children():
		$Panel/VBoxContainer/ScrollContainer/VBoxContainer.remove_child(child)
	if database.empty():
		$Panel/NoResults.visible = true
	else:
		$Panel/NoResults.visible = false
	for x in database:
		var new_button = button.instance()
		new_button = new_button.duplicate()
		new_button.rect_min_size = Vector2(0,75)
		new_button.can_drag = true
		new_button.id = "search"
		new_button.ids_allowed.clear()
		new_button.set_size(Vector2(695,75))
		new_button.set_v_size_flags(1)
		new_button.pokeButton(x)
		$Panel/VBoxContainer/ScrollContainer/VBoxContainer.add_child(new_button)

func _on_Search_pressed():
	if not search_bar.text.empty():
		tags.append(search_bar.text)
	show_tags()
	search_bar.text = ""
	auto_complete()
	showResults(Pokemon.tag_search(tags))
	grab_focus()



func check_tutorial():
	if (not Trainer.has_had_tutorial("search")) and Trainer.have_tutorial:
		var tutor = Dialogic.start("Search")
		get_tree().root.get_node("Control").add_child(tutor)
		tutor.set_layer(3)
		get_tree().root.get_node("Control").move_child(tutor,get_tree().root.get_node("Control").get_child_count()-1)
		Trainer.set_tutorial_to_finished("search")
	elif not Trainer.have_tutorial:
		Trainer.set_tutorial_to_finished("search")
