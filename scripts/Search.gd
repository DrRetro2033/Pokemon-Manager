extends Control

signal search(search)
var button = load("res://Pokemon_Button.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body

func _on_LineEdit_text_entered(new_text):
	for child in $Panel/ScrollContainer/VBoxContainer.get_children():
		child.queue_free()
	var search_criteria = {}
	search_criteria["nickname"] = $Panel/Nickname.text
	print(search_criteria.nickname)
	search_criteria["type1"] = $"Panel/Type 1".get_selected_id()
	search_criteria["type2"] = $"Panel/Type 2".get_selected_id()
	search_criteria["gender"] = $Panel/Gender.get_selected_id()
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
			new_button.rect_min_size = Vector2(0,100)
			new_button.can_drag = false
			new_button.set_size(Vector2(695,100))
			new_button.pokeButton(x)
			$Panel/ScrollContainer/VBoxContainer.add_child(new_button)


func _on_Button_pressed():
	visible = true


func _on_Back_pressed():
	visible = false


func _on_Search_pressed():
	for child in $Panel/ScrollContainer/VBoxContainer.get_children():
		child.queue_free()
	var search_criteria = {}
	search_criteria["nickname"] = $Panel/Nickname.text
	print(search_criteria.nickname)
	search_criteria["type1"] = $"Panel/Type 1".get_selected_id()
	search_criteria["type2"] = $"Panel/Type 2".get_selected_id()
	search_criteria["gender"] = $Panel/Gender.get_selected_id()
	print("Search")
	var results = Pokemon.search(search_criteria)
	showResults(results)
