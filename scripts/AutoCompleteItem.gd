extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
class_name AutoCompleteItem
var item = ""
var element_font_path = "res://fonts/Essentiarum Regular.ttf"
var gender_font_path = "res://fonts/FemaleAndMaleSymbols-BLql.ttf"
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func gender(var gender : int):
	match gender:
		0:
			$Icons/Icon.text = "m"
			return "Male"
		1:
			$Icons/Icon.text = "f"
			return "Female"
		2:
			$Icons/Icon.text = "h"
			return "Nonbinary"

func set_item(lab:String):
	item = lab
	$Icons/Icon.visible = false
	$Icons/TextureRect.visible = false
	if lab.begins_with("type:"):
		$Icons/Icon.visible = true
		var font : DynamicFont = $Icons/Icon.get_font("font").duplicate()
		font.font_data = load(element_font_path)
		$Icons/Icon.add_font_override("font",font)
		$Icons/Icon.text = Pokemon.type_chars[Pokemon.types[lab.split(':')[1]]]
		lab = lab.split(':')[1].capitalize()
	elif lab.begins_with("trainer:"):
		lab = lab.split(":")[1]
		lab = lab.split(',')[0]
		$Icons/TextureRect.visible = true
	elif lab.begins_with("gender:"):
		$Icons/Icon.visible = true
		var font : DynamicFont = $Icons/Icon.get_font("font")
		font.font_data = load(gender_font_path)
		$Icons/Icon.add_font_override("font",font)
		lab = gender(int(lab.split(':')[1]))
	$Icons/Name.text = lab

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
