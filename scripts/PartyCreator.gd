extends WindowDialog

onready var list = $Panel/ScrollContainer/VBoxContainer
onready var parties = $Panel/Parties
var button = load("res://scenes/Pokemon_Button.tscn")
var party = load("res://scenes/Party.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		if child is TextureButton:
			child.connect("pressed",self,"disapper")
	disapper()

func showPartyMaker():
	popup_centered()

func _on_Back_pressed():
	clearPokemon()
	visible = false

func clearPokemon():
	for child in list.get_children():
		child.queue_free()

func _on_AddParty_pressed():
	var new_party = party.instance()
	var copy_num = 0
	while(true):
		var exists = false
		new_party.name = "Party "+str(parties.get_child_count()+1+copy_num)
		print(new_party.name)
		for existing_party in parties.get_children():
			if new_party.name == existing_party.name:
				exists = true
		copy_num += 1
		if exists:
			copy_num += 1
			continue
		break
	parties.add_child(new_party)
	parties.current_tab = parties.get_tab_count()-1

func listPokemon(pokemon):
	for x in pokemon:
		var new_button = button.instance()
		new_button.rect_min_size = Vector2(0,100)
		new_button.set_size(Vector2(695,100))
		new_button.pokeButton(x)
		list.add_child(new_button)


func _on_Parties_tab_changed(tab):
	var party = parties.get_tab_control(tab)
	var party_array = party.get_pokemon_in_party()

func save(bank):
	var parties_order = []
	for child in parties.get_children():
		parties_order.push_back(child.name)
	bank.parties_order = parties_order

func loadParties(bank):
	for child in parties.get_children():
		child.free()
	for party_name in bank.parties_order:
		print(party_name)
		var new_party = party.instance()
		new_party.name = party_name
		parties.add_child(new_party)
		new_party.set_pokemon_in_party(bank.parties[party_name])

func move_to_center():
	rect_position = OS.window_size/2 - rect_size/2

func _on_Export_pressed():
	var party = parties.get_tab_control(parties.current_tab).get_pokemon_in_party()
	var party_to_showdown = ""
	for member in party:
		if member == null:
			continue
		else:
			party_to_showdown += PokemonShowdown.export_to_showdown(Pokemon.pokemon[member])
	OS.clipboard = party_to_showdown
	$NativeDialogMessage.show()


func _on_RemoveParty_pressed():
	if $Panel/Parties.get_child_count() != 1:
		var party = $Panel/Parties.get_tab_control($Panel/Parties.current_tab)
		if $Panel/Parties.current_tab != 0:
			$Panel/Parties.current_tab = $Panel/Parties.current_tab - 1
		else:
			$Panel/Parties.current_tab = $Panel/Parties.current_tab + 1
		$Panel/Parties.remove_child(party)
		party.queue_free()

func _on_View_pressed():
	var party = parties.get_tab_control(parties.current_tab)
	var party_array = party.get_pokemon_in_party()
	$PartyViewer.showParty(party_array)


func _on_PartyCreator_visibility_changed():
	pass

func disapper():
	print("Disapper!")
	rect_position = Vector2(-2500,-2500)
