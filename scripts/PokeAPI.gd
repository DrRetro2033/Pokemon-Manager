extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const url = "https://pokeapi.co/api/v2/"
var info : Dictionary #basic info for the pokemon
var moves : Dictionary #hold all known moves a pokemon has
var flavor_text : String #the first pokedex entry that a pokemon has
var form : int #what alt form the pokemon is
var pokemon_url : String
var data_translate = load("res://scripts/Pokemon_Database.gd").new()
signal done(info)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func update_info(array):
	form = array["form"] #tells the species request which form the pokemon is
	$SpeciesRequest.request(url+"pokemon-species/"+str(int(array["species"])))
	yield($SpeciesRequest, "request_completed")
	array["level"] = Pokemon.level(array["exp"],info["growth"]) #converts the pokemon total exp and converts it the pokemon's level
	array["growth"] = info["growth"]
	array["egg_groups"] = info["egg_groups"]
	$PokemonRequest.request(pokemon_url)
	yield($PokemonRequest, "request_completed")
	var move_names = ["move1","move2","move3","move4"] 
	for x in move_names:
		var move_id = int(array[x])
		if array[x] > 0:
			$MoveRequest.request(url+"move/"+str(int(array[x])))
			yield($MoveRequest, "request_completed")
			array[x] = {}
			array[x]["id"] = move_id
			array[x]["name"] = moves["name"]
			array[x]["typing"] = moves["typing"]
			array[x]["form"] = moves["form"]
			array[x]["pp"] = moves["pp"]
			array[x]["power"] = moves["power"]
			array[x]["text"] = moves["text"]
			array[x]["accuracy"] = 0
		else: #if there is no move, then set all move info to default
			array[x] = {}
			array[x]["name"] = "-"
			array[x]["typing"] = "-"
			array[x]["form"] = "-"
			array[x]["pp"] = 0
			array[x]["power"] = 0
			array[x]["text"] = ""
			array[x]["accuracy"] = 0
	array["species"] = info["species"]
	array["sprite"] = info["sprite"] 
	array["species-name"] = info["species-name"]
	if array["nickname"] == "": #if the nickname is blank then that means that the pokemon's name is just it's species name
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
	emit_signal("done",info)

func _on_SpeciesRequest_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	var data = json.result
	var text = data.flavor_text_entries
	for x in text:
		var characters = "abcdefghijklmnopqrstuvwxyz.,'`é?!1234567890-’" #will be removed
		if x.language.name == "en":
			flavor_text = x.flavor_text
			flavor_text = StupidCharacters.removeEscapechars(flavor_text)
			print(flavor_text)
			break
		else:
			continue
	var temp_varties = data.varieties[form]
	pokemon_url = temp_varties.pokemon.url
	info["growth"] = data.growth_rate.name
	info["egg_groups"] = Pokemon.EggGroups(data.egg_groups)
#	print(info["growth"])
	$SpeciesRequest.cancel_request()

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
	var pos = 0
	var flavor_text_entries = data.flavor_text_entries
	while pos <= flavor_text_entries.size()-1:
		if flavor_text_entries[pos]["language"]["name"] == "en":
			moves["text"] = flavor_text_entries[pos].flavor_text
			break
		pos += 1
	$MoveRequest.cancel_request()


