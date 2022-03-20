extends VBoxContainer

enum damage_class {
	NULL,
	PHYSICAL,
	SPECIAL,
	STATUS
}

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
	var new_form
	match form:
		damage_class.PHYSICAL:
			node.color = Color("#9f0000")
			var texture = load("res://Physical.svg")
			node.get_child(0).set_texture(texture)
		damage_class.SPECIAL:
			node.color = Color("#18203a")
			var texture = load("res://Special.svg")
			node.get_child(0).set_texture(texture)
		damage_class.STATUS:
			node.color = Color("#525252")
			var texture = load("res://Status.svg")
			node.get_child(0).set_texture(texture)
