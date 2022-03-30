extends VBoxContainer
const default_scale = 27
const default_size = 22
enum damage_class {
	NULL,
	PHYSICAL,
	SPECIAL,
	STATUS
}

func _process(delta):
	var font = $Row2/Type/Label.get_font("font","Label")
	font.size = default_size + int($Row2/Type.rect_size.y - default_scale)
	$Row2/Type/Label.add_font_override("font",font)

func move(move,type,form,pp,power):
	print(type)
	get_parent().get_parent().types(type,$Row2/Type)
	damage_form(form,$Row2/Form)
	if not move == "-":
		$Label.visible = true
		$Row1.visible = true
		$Row2.visible = true
		var move_name = move.split("-",true,0)
		var uppercase_name = ""
		for i in move_name:
			i[0] = i.left(1).to_upper()
			uppercase_name += i+" "
		$Label.text = uppercase_name
	else:
		$Label.visible = false
		$Row1.visible = false
		$Row2.visible = false
	if power == null:
		$Row1/Power.text = "-"
	else:
		$Row1/Power.text = str(power)
	$Row1/PP.text = str(pp)

func damage_form(var form,var node):
	var new_form = node.get_stylebox("panel").duplicate()
	match form:
		damage_class.PHYSICAL:
			new_form.set_bg_color(Color("#9f0000"))
			var texture = load("res://Physical.svg")
			node.get_child(0).set_texture(texture)
		damage_class.SPECIAL:
			new_form.set_bg_color(Color("#18203a"))
			var texture = load("res://Special.svg")
			node.get_child(0).set_texture(texture)
		damage_class.STATUS:
			new_form.set_bg_color(Color("#525252"))
			var texture = load("res://Status.svg")
			node.get_child(0).set_texture(texture)
	node.add_stylebox_override("panel",new_form)
