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
	party.push_back($VBoxContainer/Member1.id)
	party.push_back($VBoxContainer2/Member2.id)
	party.push_back($VBoxContainer/Member3.id)
	party.push_back($VBoxContainer2/Member4.id)
	party.push_back($VBoxContainer/Member5.id)
	party.push_back($VBoxContainer2/Member6.id)
	return party

func set_pokemon_in_party(party):
	$VBoxContainer/Member1.pokeButton(party[0])
	$VBoxContainer2/Member2.pokeButton(party[1])
	$VBoxContainer/Member3.pokeButton(party[2])
	$VBoxContainer2/Member4.pokeButton(party[3])
	$VBoxContainer/Member5.pokeButton(party[4])
	$VBoxContainer2/Member6.pokeButton(party[5])
func _on_Member1_dragged_and_dropped():
	get_parent().get_parent().get_parent().newMember(get_pokemon_in_party())


func _on_Member3_dragged_and_dropped():
	get_parent().get_parent().get_parent().newMember(get_pokemon_in_party())


func _on_Member5_dragged_and_dropped():
	get_parent().get_parent().get_parent().newMember(get_pokemon_in_party())


func _on_Member2_dragged_and_dropped():
	get_parent().get_parent().get_parent().newMember(get_pokemon_in_party())


func _on_Member4_dragged_and_dropped():
	get_parent().get_parent().get_parent().newMember(get_pokemon_in_party())


func _on_Member6_dragged_and_dropped():
	get_parent().get_parent().get_parent().newMember(get_pokemon_in_party())
