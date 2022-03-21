extends Node
onready var bank = $"Bank Manager"
const url = "https://pokeapi.co/api/v2/"
const pokemon_path = "res://pkmdb/"
var data_translate = load("res://scripts/Pokemon_Database.gd").new()
var pk5 = load("res://scripts/pk5.gd").new()
var pk6 = load("res://scripts/pk6.gd").new()
var pk7 = load("res://scripts/pk7.gd").new()
var walking_pokemon = load("res://WalkingPokemon.tscn") #this is the scene that contains the animations and sprite of the pokemon walking into the bank
var info : Dictionary #basic info for the pokemon
var moves : Dictionary #hold all known moves a pokemon has
var flavor_text : String #the first pokedex entry that a pokemon has
var form : int #what alt form the pokemon is
var growth : String #the speed at which pokemon level up at (needed for converting exp to levels)
var pokemon_url : String
func _ready():
	print(BinaryTranslator.bin_to_int(BinaryTranslator.int_to_bin(2254250705))) #this is for testing the binary translator by having it convert this number to binary and back
	var dir = Directory.new() #instances a new directory object
	var path : String = OS.get_executable_path().get_base_dir()+"/pkmdb"
	$"Loading Screen".switch("reading")
	var user_pokemon
	if path == "C:/Program Files (x86)/Steam/steamapps/common/Godot Engine/pkmdb": #this is only for testing purposes as I keep the pkmdb folder in this directory
		user_pokemon = list_files_in_directory(pokemon_path) #lists all of the pk files in pkmdb folder
	else:
		user_pokemon = list_files_in_directory(path)
	var existing_pokemon = bank.load() #loads the bank file of existing pokemon info
	if existing_pokemon.first_time_setup: #checks to see if this the first time the user is using pokemon manager 
		Trainer.first_time_setup = true
	else:
		Trainer.trainer_name = existing_pokemon.trainer_name
		Trainer.trainer_picture = existing_pokemon.trainer_picture
		Trainer.first_time_setup = false
		$ProfilePic/Pic.texture = existing_pokemon.trainer_picture
	#this chunk of code's job is to get all of the pokemon that already exists in the bank and remove null/empty slots
	var without_null = []
	if existing_pokemon.data != {}:
		for x in existing_pokemon.data:
			if x == null:
				continue
			elif x != null:
				without_null.push_back(x)
	# 
		if user_pokemon.size() > without_null.size(): #if the user_pokemon is bigger than without_null then that means that there is new pokemon in the pkmdb folder
			get_info(user_pokemon,existing_pokemon)
		else:
			Pokemon.set_data(existing_pokemon.data)
			$TabContainer.loadPokemon(existing_pokemon)
			$PartyCreator.loadParties(existing_pokemon)
	else:
		get_info(user_pokemon,existing_pokemon)


func get_info(user_pokemon, existing_pokemon):
	var id = 0 #this is for giving the pokemon unqie keys
	var pokemon = {}
	var order = []
	$"Loading Screen/ProgressBar".max_value = user_pokemon.size() #sets the progress bar's max value to the amount of pokemon the user has
	if existing_pokemon != null and not existing_pokemon.data.empty(): #checks to see if there is any existing pokemon in the bank file and if there is then add them to the database
		pokemon = existing_pokemon.data
		order = existing_pokemon.order
	while user_pokemon.size() > 0:
		var array #tempory array for personal data about the pokemon
		var file = user_pokemon.front()
		user_pokemon.remove(0) #removes the pokemon so that godot does not read it again and get stuck in a loop
		match file.get_extension(): #switches to the correct pk script to read the pk file
			"pk5":
				array = pk5.readpk(file)
			"pk6":
				array = pk6.readpk(file)
			"pk7":
				array = pk7.readpk(file)
		if existing_pokemon != null and not existing_pokemon.data.empty() and pokemon.has(array["id"]): #if the pokemon is already in the database, skip it
				print(array)
				id += 1
				continue
		else: #asks PokeAPI for infomation about the pokemons species and known moves
			$"Loading Screen".switch("api") #changes loading screen text
			form = array["form"] #tells the species request which form the pokemon is
			$SpeciesRequest.request(url+"pokemon-species/"+str(int(array["species"])))
			yield($SpeciesRequest, "request_completed")
			$PokemonRequest.request(pokemon_url)
			yield($PokemonRequest, "request_completed")
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
					else: #if there is no move, then set all move info to default
						array[x] = {}
						array[x]["name"] = "-"
						array[x]["typing"] = "-"
						array[x]["form"] = "-"
						array[x]["pp"] = 0
						array[x]["power"] = 0
						array[x]["accuracy"] = 0
			array["level"] = Pokemon.level(array["exp"],growth) #converts the pokemon total exp and converts it the pokemon's level
			array["species"] = info["species"]
			array["sprite"] = info["sprite"] 
			array["species-name"] = info["species-name"]
			if array["nickname"] == "":
				array["nickname"] = info["species-name"].capitalize()
			array["type1"] = info["type1"]
			array["type2"] = info["type2"]
			array["hp"] = info["hp"]
			array["atk"] = info["atk"]
			array["def"] = info["def"]
			array["spa"] = info["spa"]
			array["spd"] = info["spd"]
			array["spe"] = info["spe"]
			array["text"] = flavor_text
			if existing_pokemon != null and existing_pokemon.data.has(array["id"]):
				id += 1
				moves.clear()
				info.clear()
				flavor_text = ""
				pokemon_url = ""
				growth = ""
				continue
			else:
				pokemon[array["id"]] = {}
				pokemon[array["id"]] = array
				order.push_back(array["id"])
				var walk = walking_pokemon.instance()
				$"Loading Screen".add_child(walk)
				walk.start(array)
			print(array)
			moves.clear()
			info.clear()
			flavor_text = ""
			pokemon_url = ""
			growth = ""
			$"Loading Screen/ProgressBar".value += 1
			id += 1
		#
	Pokemon.set_data(pokemon)
	$"Loading Screen".switch("layout")
	$TabContainer.addPokemon(order)

	
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
	var hp = data.stats[0]
	var atk = data.stats[1]
	var def = data.stats[2]
	var spa = data.stats[3]
	var spd = data.stats[4]
	var spe = data.stats[5]
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
	var sprite = data["sprites"]["versions"]["generation-viii"]["icons"]["front_default"]
	sprite = sprite.get_file()
	info = {
		"species" : data.id,
		"species-name" : species, 
		"type1" : type1, 
		"type2" : type2, 
		"hp" : hp.base_stat,
		"atk" : atk.base_stat,
		"def" : def.base_stat,
		"spa" : spa.base_stat,
		"spd" : spd.base_stat,
		"spe" : spe.base_stat,
		"sprite" : sprite,
	}
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
			flavor_text = x.flavor_text
			flavor_text = removeEscapechars(flavor_text)
			print(flavor_text)
			break
		else:
			continue
	var temp_varties = data.varieties[form]
	pokemon_url = temp_varties.pokemon.url
	growth = data.growth_rate.name
	print(growth)
	$SpeciesRequest.cancel_request()

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

func removeEscapechars(text):
	var ascii_text = Array(flavor_text.to_utf8())
	while ascii_text.has(12):
		var pos = ascii_text.find(12)
		ascii_text.remove(pos)
		ascii_text.insert(pos,32)
	while ascii_text.has(10):
		var pos = ascii_text.find(10)
		ascii_text.remove(pos)
		ascii_text.insert(pos,32)
	text = PoolByteArray(ascii_text).get_string_from_utf8()
	return text
