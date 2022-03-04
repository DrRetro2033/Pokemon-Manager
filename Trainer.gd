extends Node
var trainer_name
var trainer_picture

func _ready():
	pass

func save(bank):
	bank.first_time_setup = false
	bank.trainer_name = trainer_name
	bank.trainer_picture = trainer_picture
