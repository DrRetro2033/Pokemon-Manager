extends Viewport


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func set_card(info):
	$PanelContainer/VBoxContainer/Sprite.texture = load("res://sprites/pokemon/official-artwork/"+info.sprite)
	$PanelContainer/VBoxContainer/Name.text = info.nickname
	$"PanelContainer/VBoxContainer/OT Trainer".text = info.ot.nickname

func get_card():
	var viewport_tex = get_texture().get_data()
	return viewport_tex
