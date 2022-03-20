extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	yield(get_tree().create_timer(0.01),"timeout")
	var test = Pokemon.pokemon["003 - Daisy - B82ABBBB6F73.pk6"]
	print(export_to_showdown(test))



func export_to_showdown(pokemon):
	var export_array : Array = [
		pokemon["nickname"]," (",pokemon["species-name"].capitalize(),")",gender(pokemon["gender"]),"new",
		"IVs: ",str(pokemon["iv_hp"])," HP / ",str(pokemon["iv_atk"])," Atk / ",str(pokemon["iv_def"])," Def / ",
		str(pokemon["iv_spa"])," SpA / ",str(pokemon["iv_spd"])," SpD / ",str(pokemon["iv_spe"])," Spe / ","new",
		"Level: ",str(pokemon["level"]),"new",
		"- ",moveName(pokemon["move1"]["name"]),"new",
		"- ",moveName(pokemon["move2"]["name"]),"new",
		"- ",moveName(pokemon["move3"]["name"]),"new",
		"- ",moveName(pokemon["move4"]["name"]),"new",
		"new"
	]
	var export_text = ""
	for part in export_array:
		if part != "new":
			export_text += part
		elif part == "new":
			var temp = Array(export_text.to_utf8())
			temp.push_back(10)
			export_text = PoolByteArray(temp).get_string_from_utf8()
	return export_text

func gender(gender):
	var text = ""
	match gender:
		0:
			text = " (M)"
		1:
			text = " (F)"
		2:
			text = ""
	return text
	

func moveName(move):
	var uppercase_name = ""
	if move != "-":
		var move_name = move.split("-",true,0)
		for i in move_name:
			i[0] = i.left(1).to_upper()
			uppercase_name += i+" "
	return uppercase_name
