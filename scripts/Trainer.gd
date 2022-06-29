extends Node
var trainer_name
var trainer_picture
var first_time_setup
var trainers = []
func _ready():
	pass

func save(bank):
	bank.first_time_setup = false
	bank.trainer_name = trainer_name
	bank.trainer_picture = trainer_picture
	bank.trainers = trainers

func addTrainer(info):
	print(trainers)
	var exists = false
	for trainer in trainers:
		if trainer["nickname"] == info["nickname"] and trainer["game"] == info["game"] and trainer["id"] == info["id"]:
			exists = true
	if !exists:
		trainers.append(info)
