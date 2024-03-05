extends Node
# This is API works some thing like this in python:
#import requests
#import os
#
#def check_and_clone_repo(username, repo_name):
#    # Set your GitHub personal access token
#    token = "YOUR_GITHUB_ACCESS_TOKEN"
#
#    # Define the API endpoint to check for repository updates
#    api_url = f"https://api.github.com/repos/{username}/{repo_name}/commits"
#
#    # Make a request to the GitHub API using your access token
#    response = requests.get(api_url, headers={"Authorization": f"token {token}"})
#
#    # Check if the request was successful
#    if response.status_code == 200:
#        # Get the SHA of the latest commit
#        latest_commit_sha = response.json()[0]["sha"]
#
#        # Check if the latest commit SHA is different from the one stored locally
#        if not os.path.exists(f"{repo_name}_commit.txt"):
#            # If this is the first time, store the commit SHA locally
#            with open(f"{repo_name}_commit.txt", "w") as file:
#                file.write(latest_commit_sha)
#        else:
#            with open(f"{repo_name}_commit.txt", "r") as file:
#                stored_commit_sha = file.read()
#            if stored_commit_sha != latest_commit_sha:
#                # Clone the repository if there's a new commit
#                os.system(f"git clone https://github.com/{username}/{repo_name}.git")
#
#                # Update the stored commit SHA
#                with open(f"{repo_name}_commit.txt", "w") as file:
#                    file.write(latest_commit_sha)
#                print(f"Repository {repo_name} has been updated.")
#            else:
#                print(f"Repository {repo_name} is already up to date.")
#    else:
#        print(f"Error: Unable to fetch data from GitHub API. Status code: {response.status_code}")
#
## Usage
#check_and_clone_repo("username", "repository_name")

const gdunzip_path = "res://addons/gdunzip/gdunzip.gd"
const url = "api-data-master/data/api/v2/"
var moves : Dictionary #holds all known moves a pokemon has
var flavor_text : String #the first pokedex entry that a pokemon has
var form : int #what alt form the pokemon is
var pokemon_url : String
var ability 
var data_translate = load("res://scripts/Pokemon_Database.gd").new()
var needs_update = false
var gdunzip = load(gdunzip_path).new() # This script is amazing and doesn't require the termial 
# or any library for zip files.
#Also, you might notice that in the code below, the zip file is not extracted.
#This is because that gdunzip has a feature that allows you to get the data of a specific file, without extracting everything.
#So I decided to not extract the file and keep it as is, as the alternatives either did not work,
#and extracting everything with gdunzip and saving as separate files was slow.
signal done(info)
signal finished_updating
signal loading_bar_max_value(value)
signal finished_checking(needs_update)
# Called when the node enters the scene tree for the first time.
func _ready():
	match OS.get_name():
		"Windows":
			$FileRequest.download_file += '.zip'

func check_for_update():
	$HTTPRequest.request("https://api.github.com/repos/PokeAPI/api-data")
	yield($HTTPRequest,"request_completed")
	emit_signal("finished_checking",needs_update)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func update_database():
	$FileRequest.request_raw("https://github.com/PokeAPI/api-data/archive/refs/heads/master.zip")

func format_path(folder,idx):
	return url+folder+'/'+str(idx)+"/index.json"

func get_info(array):
	var report : ErrorCorrection.ErrorReport = ErrorCorrection.check_for_errors(array)
	print(report.report)
	form = array["form"] #tells the species request which form the pokemon is
	print(format_path("pokemon-species",array["species"]))
	if gdunzip.buffer_size == null:
		gdunzip.load(ProjectSettings.globalize_path("user://database/")+"/database.zip")
	if report.check_passed(report.Checks.SPECIES):
		array = get_species(array)
		yield(get_tree(),"idle_frame")
		array = get_form(array)
	array = get_moves(array,report)
	yield(get_tree(),"idle_frame")
	if array["nickname"] == "" and report.check_passed(report.Checks.SPECIES): #if the nickname is blank then that means that the pokemon's name is just it's species name
		array["nickname"] = array["species-name"].capitalize()
	array["text"] = flavor_text
	array["ability"] = ability
	array = check_for_overrides(array)
	return array

func get_species(array):
	var body : PoolByteArray = gdunzip.uncompress(format_path("pokemon-species",array["species"]))
	var json = JSON.parse(body.get_string_from_utf8())
	var data = json.result
	var text = data.flavor_text_entries
	for x in text:
		var characters = "abcdefghijklmnopqrstuvwxyz.,'`é?!1234567890-’" #will be removed
		if x.language.name == "en":
			flavor_text = x.flavor_text
			flavor_text = StupidCharacters.removeEscapechars(flavor_text)
			break
		else:
			continue
	var temp_varties = data.varieties[form]
	pokemon_url = temp_varties.pokemon.url.get_slice('/',temp_varties.pokemon.url.split('/').size()-2)
	array["growth"] = data.growth_rate.name
	array["egg_groups"] = Pokemon.EggGroups(data.egg_groups)
	array["level"] = Pokemon.level(array["exp"],array["growth"]) #converts the pokemon total exp and converts it the pokemon's level
	return array

func get_form(array):
	var body = gdunzip.uncompress(format_path("pokemon",pokemon_url))
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
	var abilities = data.abilities.duplicate()
	print(abilities)
	ability = null
	for abi in abilities:
		if abi.slot == array["ability_number"]:
			ability = abi
	if ability == null:
		ability = abilities[0]
	array["ability"] = ability
	print(array["ability"])
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
	array.merge({
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
	},true)
	return array

func get_moves(array,report):
	var move_names = ["move1","move2","move3","move4"] 
	for x in move_names:
		var move_id = int(array[x])
		match move_names:
			"move1":
				if not report.passed_check(report.Checks.MOVE_1):
					continue
			"move2":
				if not report.passed_check(report.Checks.MOVE_2):
					continue
			"move3":
				if not report.passed_check(report.Checks.MOVE_3):
					continue
			"move4":
				if not report.passed_check(report.Checks.MOVE_4):
					continue
		if array[x] > 0:
			var body = gdunzip.uncompress(format_path("move",str(int(array[x]))))
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
	return array

func check_for_overrides(array):
	var file = File.new()
	var error = file.open("res://database/override.json",File.READ)
	if error != OK:
		return array
	var body = file.get_as_text()
	body = body.replace("\t","")
	body = body.replace("\n","")
	var json = JSON.parse(body)
	var data = json.result
	var species = str(array.species)
	if data.has(species):
		for key in data[species].keys():
			array[key] = data[species][key]
	return array

func _on_HTTPRequest_request_completed(result, response_code, headers, body):
#	print("Result: "+str(result))
#	print("Response: "+str(response_code))
#	print(headers[6])
#	print(headers)
	var dir = Directory.new()
	var json = JSON.parse(body.get_string_from_utf8())
	var data = json.result
	if response_code == 200:
		if data != null:
			print(data.pushed_at)
			var file = File.new()
			if not file.file_exists("user://database/version.txt"):
				needs_update = true
				if not dir.dir_exists("user://database/"):
					dir.make_dir("user://database/")
				file.open("user://database/version.txt",File.WRITE)
				file.store_line(data.pushed_at)
				file.close()
			else:
				file.open("user://database/version.txt",File.READ_WRITE)
				if file.is_open() and file.get_line() != data.pushed_at:
					needs_update = true
					file.seek(0)
					file.store_line(data.pushed_at)
				else:
					needs_update = false
				file.close()
	else:
		needs_update = false
	print("Needs Update: "+str(needs_update))
	$HTTPRequest.cancel_request()

func get_data(url:String):
	if gdunzip.buffer_size == null:
		gdunzip.load(ProjectSettings.globalize_path("user://database/")+"/database.zip")
	if url.begins_with("/api/v2/"):
		url = url.replace("/api/v2/","")
	print(self.url+url+"index.json")
	var body : PoolByteArray = gdunzip.uncompress(self.url+url+"index.json")
	var json = JSON.parse(body.get_string_from_utf8())
	var data = json.result
	return data.duplicate()

func _on_FileRequest_request_completed(result, response_code, headers, body):
	var exit_code = 0
	print(ProjectSettings.globalize_path("user://database/"))
	gdunzip.load(ProjectSettings.globalize_path("user://database/")+"/database.zip")
	print("Exit Code: "+str(exit_code))
	$FileRequest.cancel_request()
	emit_signal("finished_updating")


