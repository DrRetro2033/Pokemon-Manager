extends Node
var trainer_name
var trainer_picture
var first_time_setup
var trainers = []
var folder_path = ""
var have_tutorial = false
var tutorials = {
	"pokemon_view":false,
	"search":false,
	"party_creator":false
}
func _ready():
	pass

func save(bank):
	bank.first_time_setup = false
	bank.trainer_name = trainer_name
	bank.trainer_picture = trainer_picture
	bank.trainers = trainers
	bank.folder_path = folder_path
	bank.tutorials = tutorials
	bank.have_tutorial = have_tutorial

func load(bank):
	trainer_name = bank.trainer_name
	trainer_picture = bank.trainer_picture
	have_tutorial = bank.have_tutorial
	trainers = bank.trainers
	tutorials = bank.tutorials

func has_had_tutorial(key):
	if tutorials.keys().has(key):
		return tutorials[key]
	return true

func set_tutorial_to_finished(key):
	if tutorials.keys().has(key):
		tutorials[key] = true

func reset_tutorials():
	for tur in tutorials.keys():
		tutorials[tur] = false

func addTrainer(info):
	print(trainers)
	var exists = false
	for trainer in trainers:
		if trainer["nickname"] == info["nickname"] and trainer["game"] == info["game"] and trainer["id"] == info["id"]:
			exists = true
	if !exists:
		trainers.append(info)
