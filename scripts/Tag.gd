tool
extends PanelContainer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
class_name Tag
var tag = ""
signal delete_tag(tag)
var element_font_path = "res://fonts/Essentiarum Regular.ttf"
var gender_font_path = "res://fonts/FemaleAndMaleSymbols-BLql.ttf"
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	rect_size = rect_min_size

func set_tag(tag:String):
	self.tag = tag
	$HBoxContainer/Type.visible = false
	$HBoxContainer/Name.visible = false
	$HBoxContainer/TextureRect.visible = false
	if Pokemon.types.has(tag):
		$HBoxContainer/Type.visible = true
		var font : DynamicFont = $HBoxContainer/Type.get_font("font").duplicate()
		font.font_data = load(element_font_path)
		$HBoxContainer/Type.add_font_override("font",font)
		types(Pokemon.types[tag])
	elif tag.begins_with("trainer:"):
		$HBoxContainer/Name.visible = true
		$HBoxContainer/TextureRect.visible = true
		$HBoxContainer/Name.text = tag.split(':')[1]
	elif tag.begins_with("gender:"):
		$HBoxContainer/Type.visible = true
		var font : DynamicFont = $HBoxContainer/Type.get_font("font").duplicate()
		font.font_data = load(gender_font_path)
		$HBoxContainer/Type.add_font_override("font",font)
		gender(int(tag.split(':')[1]))

func gender(var gender : int):
	var gender_styles = get_stylebox("panel").duplicate()
	match gender:
		0:
			$HBoxContainer/Type.text = "m"
			gender_styles.set_bg_color(Color("#12a7da"))
		1:
			$HBoxContainer/Type.text = "f"
			gender_styles.set_bg_color(Color("#fc92ff"))
		2:
			$HBoxContainer/Type.text = "h"
			gender_styles.set_bg_color(Color("#424242"))
	add_stylebox_override("panel",gender_styles)

func types(var type):
	$HBoxContainer/Type.text = Pokemon.type_chars[type]
	var box = get_stylebox("panel").duplicate()
	box.bg_color = Pokemon.type_colors[type]
	add_stylebox_override("panel",box)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():
	emit_signal("delete_tag",tag)
