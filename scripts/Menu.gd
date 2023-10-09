extends Control
onready var bank = $"../Bank Manager"
const warning = "Resetting Pokémon Manager means removing all Pokémon, Trainers, Parties, and etc. Your pk files will be safe. \n\n Are you sure you want to continue?"
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
	$NativeDialogMessage.set_text(warning)
	$NativeDialogMessage.show()

func _on_Main_Menu_pressed():
	visible = true


func _on_Back_pressed():
	visible = false


func _on_NativeDialogMessage_result_selected(result):
	print(result)
	match result:
		0:
			bank.reset()
			get_tree().quit()
		1:
			pass

