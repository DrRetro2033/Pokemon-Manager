extends PopupPanel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_ProfilePic_pressed():
	$VBoxContainer/TextureRect.texture = Trainer.trainer_picture
	$VBoxContainer/Label.text = Trainer.trainer_name
	popup()


func _on_Main_Menu_pressed():
	visible = false


func _on_Showdown_pressed():
	OS.shell_open("https://play.pokemonshowdown.com/")
	visible = false
