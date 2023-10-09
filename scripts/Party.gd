extends GridContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func save(bank):
	bank.parties[name] = get_pokemon_in_party()

func get_pokemon_in_party():
	var party = []
	party.push_back($VBoxContainer/Member1.info)
	party.push_back($VBoxContainer2/Member2.info)
	party.push_back($VBoxContainer/Member3.info)
	party.push_back($VBoxContainer2/Member4.info)
	party.push_back($VBoxContainer/Member5.info)
	party.push_back($VBoxContainer2/Member6.info)
	return party

func set_pokemon_in_party(party):
	$VBoxContainer/Member1.pokeButton(party[0])
	$VBoxContainer2/Member2.pokeButton(party[1])
	$VBoxContainer/Member3.pokeButton(party[2])
	$VBoxContainer2/Member4.pokeButton(party[3])
	$VBoxContainer/Member5.pokeButton(party[4])
	$VBoxContainer2/Member6.pokeButton(party[5])


func _on_Member_dragged_and_dropped(node):
	var party = get_pokemon_in_party()
	if party.count(node.info) > 1:
		node.pokeButton(null)
