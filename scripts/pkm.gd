extends Node
onready var bank = $"Bank Manager"
const url = "https://pokeapi.co/api/v2/"
const pokemon_path = "res://pkmdb/"
var data_translate = load("res://scripts/Pokemon_Database.gd").new()
var pk5 = load("res://scripts/pk5.gd").new()
var pk6 = load("res://scripts/pk6.gd").new()
var pk7 = load("res://scripts/pk7.gd").new()
var folder_path : String = "/"
var existing_pokemon : Resource

func _ready():
	get_tree().set_auto_accept_quit(false)
	PM.load_settings(OS.get_user_data_dir().plus_file("settings.cfg"))
	if ProjectSettings.get_setting("Settings/General/start_up_background_music_volume") > 0.0:
		$"Loading Screen/AudioStreamPlayer".volume_db = lerp(-30,0,ProjectSettings.get_setting("Settings/General/start_up_background_music_volume"))
	else:
		$"Loading Screen/AudioStreamPlayer".volume_db = -120
	change_background_music()
	print(BinaryTranslator.bin_to_int(BinaryTranslator.int_to_bin(2254250705))) #this is for testing the binary translator by having it convert this number to binary and back
#	var dir = Directory.new() #instances a new directory object
#	dir.open(folder_path)
	$"Loading Screen".switch("reading")
	var user_pokemon
	existing_pokemon = bank.load() #loads the bank file of existing pokemon info
	Pokemon.connect("refresh_bank",self,"refresh_bank")
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
	var final_list = []
	for file in user_pokemon:
		if file.get_extension() == "pk5":
			pass
		elif file.get_extension() == "pk6":
			pass
		elif file.get_extension() == "pk7":
			pass
		else:
			continue
		final_list.append(file)
	user_pokemon = final_list
	if existing_pokemon.data != {}:
		for x in existing_pokemon.data:
			if x == null:
				continue
			elif x != null:
				without_null.push_back(x)
		print(existing_pokemon)
		print(without_null)
		if user_pokemon.size() > without_null.size(): #if the user_pokemon is bigger than without_null then that means that there is new pokemon in the pkmdb folder
			get_info(user_pokemon,existing_pokemon)
		elif without_null.size() == 0:
			get_info(user_pokemon,existing_pokemon)
		else:
			Pokemon.set_data(existing_pokemon.data)
			$TabContainer.loadPokemon(existing_pokemon)
			$Windows/PartyCreator.loadParties(existing_pokemon)
	else:
		get_info(user_pokemon,existing_pokemon)

func change_background_music(): #Changes background music to what the user selected.
	$"Loading Screen/AudioStreamPlayer".stop()
	var music
	if ProjectSettings.get_setting("Settings/General/start_up_background_music_name") == "rando":
		var files = []
		var dir1 = Directory.new()
		dir1.open("res://sound/startup_background_music/")
		dir1.list_dir_begin()
		while true:
			var file = dir1.get_next()
			if file == "":
				break
			elif file.ends_with("."):
				continue
			elif not file.ends_with(".import"):
				files.append("res://sound/startup_background_music/"+file)
		dir1.list_dir_end()
		var rand = RandomNumberGenerator.new()
		rand.randomize()
		print(files)
		music = files[rand.randi_range(0,files.size()-1)]
	else:
		music = ProjectSettings.get_setting("Settings/General/start_up_background_music_name")
	$"Loading Screen/AudioStreamPlayer".stream = load(music)
	$"Loading Screen/AudioStreamPlayer".play(0.0)

func get_info(user_pokemon, existing_pokemon):
	print(user_pokemon)
	var id = 0 #this is for giving the pokemon unqie keys
	var pokemon = {}
	var new_pokemon = []
	$"Loading Screen".switch("api")
	API.check_for_update()
	var needs_update = yield(API,"finished_checking")
	print("Needs Update: "+str(needs_update))
	if needs_update:
		$"Loading Screen".switch("extracting")
		API.update_database()
		yield(API,"finished_updating")
	$"Loading Screen/ProgressBar".max_value = user_pokemon.size() #sets the progress bar's max value to the amount of pokemon the user has
	$"Loading Screen/ProgressBar".value = 0
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
		if array == null:
			continue
		if existing_pokemon != null and not existing_pokemon.data.empty() and pokemon.has(array["id"]): #if the pokemon is already in the database, skip it
				id += 1
				continue
		elif array != null and not array.empty(): #asks PokeAPI for infomation about the pokemons species and known moves
			$"Loading Screen".switch("moving") #changes loading screen text
			var info = API.get_info(array).duplicate()
			#this should be removed in the future
			if existing_pokemon != null and existing_pokemon.data.has(array["id"]): 
				id += 1
				info.clear()
			else:
				pokemon[array["id"]] = {}
				pokemon[array["id"]] = array
				new_pokemon.push_back(array["id"])
				#this part creates and starts the walking pokemon
				$"Loading Screen/WalkingPokemon".add_pokemon(array)
#			print(array)
			$"Loading Screen/ProgressBar".value += 1
			id += 1
			yield(get_tree().create_timer(1),"timeout")
		#
	if pokemon.empty():
		print("Incorrect")
		$NativeDialogSelectFolder.initial_path = OS.get_executable_path()
		$NativeDialogSelectFolder.show()
		folder_path = yield($NativeDialogSelectFolder,"folder_selected")
		print(folder_path)
		get_info(list_files_in_directory(folder_path),existing_pokemon)
	else:
		Trainer.folder_path = folder_path
		Pokemon.set_data(pokemon) #makes a copy of the temporary dictionary and gives it to the object Pokemon for public access
		$"Loading Screen".switch("layout")
		$TabContainer.addPokemon(new_pokemon)


func refresh_bank(new_pokemon):
	print("refresh")
	$TabContainer.addPokemon(new_pokemon)
	

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
	$RightClickContext.position = get_viewport().get_mouse_position()
	if Input.is_action_just_pressed("right_click"):
		right_click()
	elif Input.is_action_just_pressed("dev_tool_menu_open"):
		pass

func right_click():
	$PopupMenu.visible = false
	if $RightClickContext.get_overlapping_areas().size() > 0:
		print($RightClickContext.get_overlapping_areas())
		var areas = $RightClickContext.get_overlapping_areas()
		areas = $Windows.reorder_right_click_areas(areas)
		print(areas)
		var x = 0
		while x < areas.size():
			if not areas[x].is_usable():
				x += 1
				continue
			else:
				$PopupMenu.open_menu(areas[x])
				break
		$PopupMenu.set_global_position(get_viewport().get_mouse_position())

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		if ProjectSettings.get_setting("Settings/General/always_ask_to_save"):
			$NativeDialogMessage.show()
		else:
			var has_saved = bank.save()
			PM.save_settings()
			if has_saved:
				get_tree().quit()

func _on_Search_pressed():
	if ProjectSettings.get_setting("Settings/Search/use_tags"):
		$Windows/TagSearch.show()
	elif ProjectSettings.get_setting("Settings/Search/use_filter"):
		$Windows/Search.show()


func _on_Party_pressed():
	$Windows/PartyCreator.show()


func _on_NativeDialogMessage_result_selected(result):
	print(result)
	match result:
		2:
			bank.save()
			PM.save_settings()
			get_tree().quit()
		3:
			get_tree().quit()
		1:
			pass


func _on_Loading_Screen_have_tutorial():
	Trainer.have_tutorial = true


func _on_Settings_pressed():
	$PopupPanel.hide()
	$Windows/Settings.refresh_settings()
	$Windows/Settings.show()

func create_new_info_panel(id):
	var panel = load("res://scenes/PokemonInfoPanel.tscn").instance()
	$Windows.add_child(panel)
	panel.open(id)
	panel.show()
