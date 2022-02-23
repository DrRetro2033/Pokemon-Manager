extends Node
onready var bank = $"Bank Manager"
var pokemon_path = "res://pkmdb/"
var data_translate = load("res://Pokemon_Database.gd").new()
var pk6 = load("res://pk6.gd").new()
var pk7 = load("res://pk7.gd").new()
var walking_pokemon = load("res://WalkingPokemon.tscn")
var info = {}
var moves = {}
var flavor_text
func _ready():
	var dir = Directory.new()
	var path : String = OS.get_executable_path().get_base_dir()+"/pkmdb"
	$"Loading Screen".switch("reading")
	var user_pokemon
	if path == "C:/Program Files (x86)/Steam/steamapps/common/Godot Engine/pkmdb":
		user_pokemon = list_files_in_directory(pokemon_path) #lists all of the pk files in pkmdb folder
	else:
		user_pokemon = list_files_in_directory(path)
	var existing_pokemon = bank.load() #loads the bank file of existing pokemon info
	var without_null = []
	if existing_pokemon.data != []:
		for x in existing_pokemon.data:
			if x == null:
				continue
			elif x != null:
				without_null.push_back(x)
		if user_pokemon.size() > without_null.size():
			get_info(user_pokemon,existing_pokemon)
			$Pokemon.set_data(without_null)
		else:
			$TabContainer.loadPokemon(existing_pokemon)
			$Pokemon.set_data(without_null)
	else:
		get_info(user_pokemon,existing_pokemon)


func get_info(user_pokemon, existing_pokemon):
	var id = 1 #this is for giving the pokemon unqie keys
	var pokemon = []
	$"Loading Screen/ProgressBar".max_value = user_pokemon.size()
	if existing_pokemon != null and not existing_pokemon.data.empty():
		pokemon = existing_pokemon.data
	while user_pokemon.size() > 0:
		var array #tempory array for personal data about the pokemon
		var file = user_pokemon.front()
		user_pokemon.remove(0)
		match file.get_extension(): #switches the correct pk script
			"pk6":
				array = pk6.readpk(file)
			"pk7":
				array = pk7.readpk(file)
		#asks PokeAPI for infomation about the pokemons species and moves
		var current
		if existing_pokemon != null and not existing_pokemon.data.empty() and pokemon.has(existing_pokemon.data[id]):
				print(array)
				id += 1
				continue
		else:
			$"Loading Screen".switch("api")
			var url = "https://pokeapi.co/api/v2/"
			$PokemonRequest.request(url+"pokemon/"+str(int(array["species"])))
			yield($PokemonRequest, "request_completed")
			array["type1"] = info["type1"]
			array["type2"] = info["type2"]
			$SpeciesRequest.request(url+"pokemon-species/"+str(int(array["species"])))
			yield($SpeciesRequest, "request_completed")
			array["text"] = flavor_text
			var move_names = ["move1","move2","move3","move4"]
			for x in move_names:
					if array[x] > 0:
						$MoveRequest.request(url+"move/"+str(int(array[x])))
						yield($MoveRequest, "request_completed")
						array[x] = {}
						array[x]["name"] = moves["name"]
						array[x]["typing"] = moves["typing"]
						array[x]["form"] = moves["form"]
						array[x]["pp"] = moves["pp"]
						array[x]["power"] = moves["power"]
						array[x]["accuracy"] = 0
					else:
						array[x] = {}
						array[x]["name"] = "-"
						array[x]["typing"] = "-"
						array[x]["form"] = "-"
						array[x]["pp"] = 0
						array[x]["power"] = 0
						array[x]["accuracy"] = 0
					moves.clear()
			array["species"] = info["species"]
			if existing_pokemon != null and existing_pokemon.data.has(array):
				id += 1
				moves.clear()
				info.clear()
				flavor_text = ""
				continue
			elif pokemon.has(null):
				var pos = pokemon.find(null,0)
				moves.clear()
				info.clear()
				flavor_text = ""
				pokemon.remove(pos)
				pokemon.insert(pos,array)
			else:
				pokemon.push_back(array)
				var walk = walking_pokemon.instance()
				$"Loading Screen".add_child(walk)
				walk.start(array)
			print(array)
			moves.clear()
			info.clear()
			flavor_text = ""
			$"Loading Screen/ProgressBar".value += 1
			id += 1
		#
	$"Loading Screen".switch("layout")
	$TabContainer.addPokemon(pokemon)
	
func list_files_in_directory(path): #lists all the pk files in the pkmdb folder
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			files.append(file)
	dir.list_dir_end()
	return files

func _on_PokemonRequest_request_completed(result,response_code,headers,body):
	var json = JSON.parse(body.get_string_from_utf8())
	var data = json.result
	var species = data.name
	var type1 = data.types[0]
	var type2
	type1 = type1.type
	type1 = type1.name
	type1 = data_translate.typing(type1)
	if data.types.size() == 2:
		type2 = data.types[1]
		type2 = type2.type
		type2 = type2.name
		type2 = data_translate.typing(type2)
	else:
		type2 = data_translate.types.NULL
	info = {"species" : species, "type1" : type1, "type2" : type2}
	$PokemonRequest.cancel_request() #stops the request 

func _on_MoveRequest_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	var data = json.result
	moves["typing"] = data_translate.typing(str(data.type.name))
	moves["form"] = data_translate.damageClass(str(data.damage_class.name))
	moves["name"] = data.name
	moves["pp"] = data.pp
	moves["power"] = data.power
	$MoveRequest.cancel_request()


func _on_SpeciesRequest_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	var data = json.result
	var text = data.flavor_text_entries
	for x in text:
		var characters = "abcdefghijklmnopqrstuvwxyz.,'`é?!1234567890-’"
		if x.language.name == "en":
			flavor_text = str(x.flavor_text)
			var fix_text = ""
			for letter in flavor_text:
				if characters.findn(letter) != -1:
					fix_text = fix_text + letter
				else:
					fix_text = fix_text + " "
			flavor_text = str(fix_text)
			break
		else:
			continue
	print(flavor_text)
	yield($PokemonRequest, "request_completed")

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		bank.save()
		get_tree().quit()
	elif Input.is_action_just_pressed("reset"):
		bank.reset()
		get_tree().quit()
	elif Input.is_action_just_pressed("right_click") and $Panel.visible != true:
		$PopupMenu.popup()
		$PopupMenu.set_global_position(get_viewport().get_mouse_position())
