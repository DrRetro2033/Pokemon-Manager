extends WindowDialog

signal search(search)
var button = load("res://scenes/Pokemon_Button.tscn")
onready var trainer = $Panel/HFlowContainer/Trainer
onready var gender = $Panel/HFlowContainer/Gender
onready var type1 = $"Panel/HFlowContainer/HFlowContainer/Type 1"
onready var type2 = $"Panel/HFlowContainer/HFlowContainer/Type 2"
onready var nickname = $Panel/HFlowContainer/Nickname
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body

func _on_LineEdit_text_entered(new_text):
	for child in $Panel/ScrollContainer/VBoxContainer.get_children():
		child.queue_free()
	var search_criteria = {}
	search_criteria["nickname"] = nickname.text
	print(search_criteria.nickname)
	search_criteria["type1"] = type1.get_selected_id()
	search_criteria["type2"] = type2.get_selected_id()
	search_criteria["gender"] = gender.get_selected_id()
	search_criteria["ot"] = trainer.get_item_metadata(trainer.get_selected_id())
	print("Search")
	var results = Pokemon.search(search_criteria)
	showResults(results)

func showResults(database):
	if database.empty():
		$Panel/NoResults.visible = true
	else:
		$Panel/NoResults.visible = false
		for x in database:
			var new_button = button.instance()
			new_button = new_button.duplicate()
			new_button.rect_min_size = Vector2(0,100)
			new_button.can_drag = true
			new_button.id = "search"
			new_button.ids_allowed.clear()
			new_button.set_size(Vector2(695,100))
			new_button.set_v_size_flags(1)
			new_button.pokeButton(x)
			$Panel/ScrollContainer/VBoxContainer.add_child(new_button)


func _on_Button_pressed():
	popup_centered()



func _on_Back_pressed():
	visible = false


func _on_Search_pressed():
	for child in $Panel/ScrollContainer/VBoxContainer.get_children():
		child.queue_free()
	var search_criteria = {}
	search_criteria["nickname"] = nickname.text
	print(search_criteria.nickname)
	search_criteria["type1"] = type1.get_selected_id()
	search_criteria["type2"] = type2.get_selected_id()
	search_criteria["gender"] = gender.get_selected_id()
	search_criteria["ot"] = trainer.get_item_metadata(trainer.get_selected_id())
	print("Search")
	var results = Pokemon.search(search_criteria)
	showResults(results)


func _on_Search_visibility_changed():
	var pos = 1
	trainer.clear()
	trainer.add_item("All Trainers",0)
	trainer.set_item_metadata(0,null)
	for train in Trainer.trainers:
		trainer.add_item(train["nickname"],pos)
		trainer.set_item_metadata(pos,train)
		pos += 1
