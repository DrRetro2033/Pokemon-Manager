extends Node
onready var bank = $"Bank Manager"
const url = "https://pokeapi.co/api/v2/"
const pokemon_path = "res://pkmdb/"
var data_translate = load("res://scripts/Pokemon_Database.gd").new()
var pk5 = load("res://scripts/pk5.gd").new()
var pk6 = load("res://scripts/pk6.gd").new()
var pk7 = load("res://scripts/pk7.gd").new()
var walking_pokemon = load("res://scenes/WalkingPokemon.tscn") #this is the scene that contains the animations and sprite of the pokemon walking into the bank
var info : Dictionary #basic info for the pokemon
var moves : Dictionary #hold all known moves a pokemon has
var flavor_text : String #the first pokedex entry that a pokemon has
var form : int #what alt form the pokemon is
var pokemon_url : String
var folder_path : String = "/"
func _ready():
	print(BinaryTranslator.bin_to_int(BinaryTranslator.int_to_bin(2254250705))) #this is for testing the binary translator by having it convert this number to binary and back
	var dir = Directory.new() #instances a new directory object
	dir.open(folder_path)
	$"Loading Screen".switch("reading")
	var user_pokemon
	var existing_pokemon = bank.load() #loads the bank file of existing pokemon info
	if existing_pokemon.first_time_setup: #checks to see if this the first time the user is using pokemon manager 
		Trainer.first_time_setup = true
	else:
		Trainer.trainer_name = existing_pokemon.trainer_name
		Trainer.trainer_picture = existing_pokemon.trainer_picture
		Trainer.first_time_setup = false
		folder_path = existing_pokemon.folder_path
		$ProfilePic/Pic.texture = existing_pokemon.trainer_picture
		Trainer.trainers = existing_pokemon.trainers
	#this chunk of code's job is to get all of the pokemon that already exists in the bank and remove null/empty slots
	var without_null = []
	user_pokemon = list_files_in_directory(folder_path)
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
	print(user_pokemon)
	var id = 0 #this is for giving the pokemon unqie keys
	var pokemon = {}
	var new_pokemon = []
	$"Loading Screen/ProgressBar".max_value = user_pokemon.size() #sets the progress bar's max value to the amount of pokemon the user has
	if existing_pokemon != null and not existing_pokemon.data.empty(): #checks to see if there is any existing pokemon in the bank file and if there is then add them to the database
		pokemon = existing_pokemon.data
	while user_pokemon.size() > 0:
		var array #tempory array for personal data about the pokemon
		var file = user_pokemon.front()
		user_pokemon.remove(0) #removes the pokemon so that godot does not read it again and get stuck in a loop
		match file.get_extension(): #switches to the correct pk script to read the pk file.
			"pk5":
				array = pk5.readpk(folder_path+"/"+file)
			"pk6":
				array = pk6.readpk(folder_path+"/"+file)
			"pk7":
				array = pk7.readpk(folder_path+"/"+file)
		if existing_pokemon != null and not existing_pokemon.data.empty() and pokemon.has(array["id"]): #if the pokemon is already in the database, skip it
				id += 1
				continue
		elif array != null and not array.empty(): #asks PokeAPI for infomation about the pokemons species and known moves
			$"Loading Screen".switch("api") #changes loading screen text
			API.update_info(array)
			info = yield(API,"done")
			#this should be removed in the future
			if existing_pokemon != null and existing_pokemon.data.has(array["id"]): 
				id += 1
				moves.clear()
				info.clear()
				flavor_text = ""
				pokemon_url = ""
				continue
			else:
			#
				pokemon[array["id"]] = {}
				pokemon[array["id"]] = array
				new_pokemon.push_back(array["id"])
				#this part creates and starts the walking pokemon
				var walk = walking_pokemon.instance()
				$"Loading Screen/WalkingPokemon".add_child(walk)
				walk.start(array)
				#
#			print(array)
			moves.clear()
			info.clear()
			flavor_text = ""
			pokemon_url = ""
			$"Loading Screen/ProgressBar".value += 1
			id += 1
		#
	if pokemon.empty():
		print("Incorrect")
		$PathSelector.popup()
		folder_path = yield($PathSelector,"dir_selected")
		print(folder_path)
		get_info(list_files_in_directory(folder_path),existing_pokemon)
	else:
		Trainer.folder_path = folder_path
		Pokemon.set_data(pokemon) #makes a copy of the temporary dictionary and gives it to the object Pokemon for public access
		$"Loading Screen".switch("layout")
		$TabContainer.addPokemon(new_pokemon,existing_pokemon)


	
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
