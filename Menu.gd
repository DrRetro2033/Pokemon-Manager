extends Control
onready var bank = $"../Bank Manager"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var reset_accept = $Panel/Reset
onready var quit_accept = $Panel/Quit

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Reset_pressed():
	reset_accept.popup()


func _on_Quit_pressed():
	quit_accept.popup()


func _on_QuitSave_pressed():
	bank.save()
	get_tree().quit()


func _on_Quit_confirmed():
	get_tree().quit()


func _on_Reset_confirmed():
	bank.reset()
	get_tree().quit()


func _on_Main_Menu_pressed():
	visible = true


func _on_Back_pressed():
	visible = false
