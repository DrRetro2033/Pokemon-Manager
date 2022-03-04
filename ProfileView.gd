extends Button


onready var trainer = $"../Trainer"

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_ProfilePic_pressed():
	$PopupPanel/VBoxContainer/TextureRect.texture = trainer.trainer_picture
	$PopupPanel/VBoxContainer/Label.text = trainer.trainer_name
	$PopupPanel.popup()
