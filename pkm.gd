extends Node
onready var bank = $"Bank Manager"
var pokemon_path = "res://pkmdb/"
var data_translate = load("res://Pokemon_Database.gd").new()
var pk6 = load("res://pk6.gd").new()
var pk7 = load("res://pk7.gd").new()
var info
var moves = []
var flavor_text
func _ready():
	var user_pokemon = list_files_in_directory(pokemon_path) #lists all of the pk files in pkmdb folder
	var existing_pokemon = bank.load() #loads the bank file of existing pokemon info
	if user_pokemon.size() > existing_pokemon.data.size():
		get_info(user_pokemon,existing_pokemon)
	else:
		$TabContainer.addPokemon(existing_pokemon.data)


func get_info(user_pokemon, existing_pokemon):
	var id = 1 #this is for giving the pokemon unqie keys
	var pokemon = []
	$"Loading Screen/ProgressBar".max_value = user_pokemon.size()
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
		if array[3] in existing_pokemon:
			continue
		else:
			var url = "https://pokeapi.co/api/v2/"
			$PokemonRequest.request(url+"pokemon/"+str(int(array[0])))
			yield($PokemonRequest, "request_completed")
			$SpeciesRequest.request(url+"pokemon-species/"+str(int(array[0])))
			yield($SpeciesRequest, "request_completed")
			array[0] = id
			while array.size() >= 5:
				if array[4] > 0:
					$MoveRequest.request(url+"move/"+str(int(array[4])))
					yield($MoveRequest, "request_completed")
					array.remove(4)
				else:
					moves.push_back(["-","-","-",0,0,0])
					array.remove(4)
			array.push_back(moves)
			pokemon.push_back([info,array,flavor_text])
			moves = []
			info = []
			flavor_text = []
			$"Loading Screen/ProgressBar".value += 1
			id += 1
		#
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
	info = [species,type1,type2]
	$PokemonRequest.cancel_request() #stops the request 

func _on_MoveRequest_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	var data = json.result
	var corrected_typing = data_translate.typing(str(data.type.name))
	var corrected_form = data_translate.damageClass(str(data.damage_class.name))
	moves.push_back([data.name,corrected_typing,corrected_form,data.pp,data.power,data.accuracy])
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
			flavor_text = [str(fix_text)]
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

