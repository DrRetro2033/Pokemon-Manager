extends Control

onready var list = $Panel/ScrollContainer/VBoxContainer
var button = load("res://Pokemon_Button.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body

func showPartyMaker():
	visible = true
	for x in Pokemon.pokemon.keys():
		var new_button = button.instance()
		new_button.rect_min_size = Vector2(0,100)
		new_button.set_size(Vector2(695,100))
		new_button.pokeButton(x)
		list.add_child(new_button)


func _on_Back_pressed():
	for child in list.get_children():
		child.queue_free()
	visible = false
