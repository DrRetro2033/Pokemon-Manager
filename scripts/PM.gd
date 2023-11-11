extends Node

# This node is the communicator between Pokémon Manager and the user's computer, 
# and contains some functions that are needed everywhere.
# It handles the dragging and droping of trading cards, saving and loading settings, dragging etc.
const warning = "{file} is either not compatible with Pokémon Manager, or has a high likelihood of being corrupted. PNG and PK (*.pk7, *.pk6, etc.) files are compatible and recommended.\n\nDo you still want to continue to read the file?"
const options_to_save = { # This dictionary states what project settings need to be saved and where to place them.
	"General":[
		"start_up_background_music_volume",
		"always_ask_to_save",
		"start_up_background_music_name",
		"hover_time_to_switch_tabs"
	],
	"Search":[
		"use_tags",
		"use_filter"
	],
}
const CFG_TEMPLATE = "settings.cfg"
var is_dragging = false
signal finished_extracting
# Called when the node enters the scene tree for the first time.

func _notification(what):
	if what == NOTIFICATION_DRAG_BEGIN:
		is_dragging = true
	elif what == NOTIFICATION_DRAG_END:
		is_dragging = false

func _ready():
	OS.min_window_size = Vector2(1024,600)
	get_tree().connect("files_dropped",self,"_on_files_dropped")

func _on_files_dropped(files, screen):
	print(files)
	var array = []
	for path in files:
		if path.get_extension() == "png":
			var img = Image.new()
			img.load(path)
			var pokemon = get_pokemon_from_img(img)
			print(pokemon)
			if pokemon == null:
				$ErrorMessage.set_text("{file} is not a valid trading card.".format({"file":path.get_file()}))
				$ErrorMessage.show()
				yield($ErrorMessage,"result_selected")
			else:
				array.append(pokemon)
		else:
			$NativeDialogMessage.set_text(warning.format({"file":path.get_file()}))
			$NativeDialogMessage.show()
			var choice = yield($NativeDialogMessage,"result_selected")

func get_pokemon_from_img(img : Image):
	var colors = get_pixel_colors_as_colors(img,Rect2(0,img.get_height()-1,31,0))
	print("HASH: "+str(colors.hash()))
	var pool = get_pixel_colors_as_pool(img,Rect2(31,img.get_height()-1,2,0))
	var binary = ""
	for byte in pool:
		binary += BinaryTranslator.int_to_bin(byte)
	print("Checksum: "+str(BinaryTranslator.bin_to_int(binary)))
	var checksum_from_colors = colors.hash()
	var checksum_from_img = BinaryTranslator.bin_to_int(binary)
	if checksum_from_colors == checksum_from_img:
		print("This is a valid Pokemon.")
	else:
		print("Invalid Pokemon.")
		return null
	var info = {}
	pool = get_pixel_colors_as_pool(img,Rect2(0,img.get_height()-1,4,0))
	info["nickname"] = pool.get_string_from_utf8()
	print(pool.get_string_from_utf8())
	pool = get_pixel_colors_as_pool(img,Rect2(4,img.get_height()-1,4,0))
	print(pool.get_string_from_utf8())
	info["ot"] = {}
	info["ot"]["nickname"] = pool.get_string_from_utf8()
	pool = get_pixel_colors_as_colors(img,Rect2(8,img.get_height()-1,1,0))
	info["ot"]["game"] = pool[0].r8
	info["ot"]["gender"] = pool[0].g8
	info["gender"] = pool[0].b8
	pool = get_pixel_colors_as_pool(img,Rect2(9,img.get_height()-1,1,0))
	var bin = BinaryTranslator.int_to_bin(pool[0]) + BinaryTranslator.int_to_bin(pool[1])
	print(BinaryTranslator.bin_to_int(BinaryTranslator.invert_binary(bin)))
	print(pool)
	info["ot"]["id"] = BinaryTranslator.bin_to_int(BinaryTranslator.invert_binary(bin))
	print(pool)
	pool = get_pixel_colors_as_pool(img,Rect2(10,img.get_height()-1,1,0))
	bin = BinaryTranslator.int_to_bin(pool[0]) + BinaryTranslator.int_to_bin(pool[1])
	info["met_location"] = BinaryTranslator.bin_to_int(bin)
	info["met_level"] = pool[2]
	pool = get_pixel_colors_as_pool(img,Rect2(11,img.get_height()-1,1,0))
	info["atk"] = pool[0]
	info["def"] = pool[1]
	info["hp"] = pool[2]
	pool = get_pixel_colors_as_pool(img,Rect2(12,img.get_height()-1,1,0))
	info["spe"] = pool[0]
	info["spa"] = pool[1]
	info["spd"] = pool[2]
	pool = get_pixel_colors_as_pool(img,Rect2(13,img.get_height()-1,1,0))
	info["iv_atk"] = pool[0]
	info["iv_def"] = pool[1]
	info["iv_hp"] = pool[2]
	pool = get_pixel_colors_as_pool(img,Rect2(14,img.get_height()-1,1,0))
	info["iv_spe"] = pool[0]
	info["iv_spa"] = pool[1]
	info["iv_spd"] = pool[2]
	pool = get_pixel_colors_as_pool(img,Rect2(15,img.get_height()-1,1,0))
	info["ev_atk"] = pool[0]
	info["ev_def"] = pool[1]
	info["ev_hp"] = pool[2]
	pool = get_pixel_colors_as_pool(img,Rect2(16,img.get_height()-1,1,0))
	info["ev_spe"] = pool[0]
	info["ev_spa"] = pool[1]
	info["ev_spd"] = pool[2]
	print(info)
	pool = get_pixel_colors_as_pool(img,Rect2(17,img.get_height()-1,1,0))
	bin = BinaryTranslator.int_to_bin(pool[0]) + BinaryTranslator.int_to_bin(pool[1])
	info["move1"] = BinaryTranslator.bin_to_int(bin)
	pool = get_pixel_colors_as_pool(img,Rect2(18,img.get_height()-1,1,0))
	bin = BinaryTranslator.int_to_bin(pool[0]) + BinaryTranslator.int_to_bin(pool[1])
	info["move2"] = BinaryTranslator.bin_to_int(bin)
	pool = get_pixel_colors_as_pool(img,Rect2(19,img.get_height()-1,1,0))
	bin = BinaryTranslator.int_to_bin(pool[0]) + BinaryTranslator.int_to_bin(pool[1])
	info["move3"] = BinaryTranslator.bin_to_int(bin)
	pool = get_pixel_colors_as_pool(img,Rect2(20,img.get_height()-1,1,0))
	bin = BinaryTranslator.int_to_bin(pool[0]) + BinaryTranslator.int_to_bin(pool[1])
	info["move4"] = BinaryTranslator.bin_to_int(bin)
	pool = get_pixel_colors_as_pool(img,Rect2(21,img.get_height()-1,2,0))
	bin = ''
	for byte in pool:
		bin += BinaryTranslator.int_to_bin(byte)
	info["exp"] = BinaryTranslator.bin_to_int(bin)
	pool = get_pixel_colors_as_pool(img,Rect2(23,img.get_height()-1,1,0))
	bin = BinaryTranslator.int_to_bin(pool[0]) + BinaryTranslator.int_to_bin(pool[1])
	info["species"] = BinaryTranslator.bin_to_int(bin)
	info["form"] = pool[2]
	pool = get_pixel_colors_as_pool(img,Rect2(24,img.get_height()-1,1,0))
	info["ability_number"] = pool[0]
	pool = get_pixel_colors_as_pool(img,Rect2(25,img.get_height()-1,6,0))
	var person_id = pool.get_string_from_utf8()
	print(create_id(info["species"],info["nickname"],person_id))
	var id = create_id(info["species"],info["nickname"],person_id)
	print("Has Pokemon: "+str(Pokemon.has_pokemon(id)))
	if not Pokemon.has_pokemon(id):
		add_pokemon(info,id)
		return id
	else:
		var override = true
		if override:
			add_pokemon(info,id)
			return id

func add_pokemon(info,id):
		var final_info = API.get_info(info)
		load("res://scripts/pk6.gd").new().writepk(Trainer.folder_path+'/'+id,final_info)
		Pokemon.add_pokemon({id:final_info})

func create_id(species,nickname,person_id):
	var string = ""
	if species < 10:
		string += "00"+str(species)
	elif species < 100:
		string += "0"+str(species)
	else:
		string += str(species)
	string += " - "
	string += nickname
	string += " - "
	string += person_id
	return string

func get_pixel_colors_as_pool(img : Image, rect : Rect2):
	var pool : PoolColorArray = []
	var current_pos : Vector2 = rect.position
	img.lock()
	while current_pos - rect.position < rect.size:
		while current_pos.x - rect.position.x < rect.size.x:
			pool.append(img.get_pixelv(current_pos))
			current_pos.x += 1
			if current_pos.x - rect.position.x > rect.size.x:
				current_pos.y += 1
				current_pos.x = rect.position.x
				break
	var array : PoolByteArray = []
	for color in pool:
		array.append(color.r8)
		array.append(color.g8)
		array.append(color.b8)
	return array

func get_pixel_colors_as_colors(img:Image,rect:Rect2):
	var pool = []
	var current_pos : Vector2 = rect.position
	img.lock()
	while current_pos - rect.position < rect.size:
		while current_pos.x - rect.position.x < rect.size.x:
			pool.append(img.get_pixelv(current_pos))
			current_pos.x += 1
			if current_pos.x - rect.position.x > rect.size.x:
				current_pos.y += 1
				current_pos.x = rect.position.x
				break
	return pool

func save_settings():
	var save_path = OS.get_user_data_dir().plus_file(CFG_TEMPLATE)
	var file = ConfigFile.new()
	for section in options_to_save.keys():
		for option in options_to_save[section]:
			file.set_value(section,option,ProjectSettings.get_setting("Settings/"+section+'/'+option))
	var error = file.save(save_path)

func reset_settings():
	var file = ConfigFile.new()
	file.load("res://data/default_settings.cfg")
	for section in file.get_sections():
		for option in file.get_section_keys(section):
			var value = file.get_value(section,option)
			ProjectSettings.set_setting("Settings/"+section+'/'+option,value)

func load_settings(path):
	var file = ConfigFile.new()
	if not File.new().file_exists(path):
		file.load("res://data/default_settings.cfg")
	else:
		file.load(path)
	for section in file.get_sections():
		for option in file.get_section_keys(section):
			var value = file.get_value(section,option)
			ProjectSettings.set_setting("Settings/"+section+'/'+option,value)

func get_all_children(node):
	var children = []
	var next_nodes = []
	var current_nodes = node.get_children()
	while true:
		children.append_array(current_nodes)
		next_nodes.clear()
		for x in current_nodes:
			if not x.get_children().empty():
				next_nodes.append_array(x.get_children())
		current_nodes = next_nodes.duplicate()
		if current_nodes.empty():
			break
	return children
