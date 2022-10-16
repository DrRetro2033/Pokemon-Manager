extends Node

const bank_loaded = preload("res://data/bank.gd")
const BANK_FOLDER : String = "user://save/"
var SAVE_NAME_TEMPLATE : String = "bank.tres"
var file_exists : bool = false

func save():
	var bank := bank_loaded.new()
	for node in get_tree().get_nodes_in_group("Parties"):
		node.save(bank)
	$"../PartyCreator".save(bank)
	$"../TabContainer".save(bank)
	bank.data = Pokemon.pokemon
	Trainer.save(bank)
	var save_path = BANK_FOLDER.plus_file(SAVE_NAME_TEMPLATE)
	var error : int = ResourceSaver.save(save_path,bank)
	if error != OK:
		print("Did not save")
		error = ResourceSaver.save("res://save/",bank)
		return false
	print("Saved succesfully")
	return true

func load():
	var path : String
	print(path)
	var save_file_path : String
	save_file_path = path.plus_file(SAVE_NAME_TEMPLATE)
	var file : File = File.new()
	if not file.file_exists(save_file_path):
		print("Bank file does not exist")
		var bank = bank_loaded.new()
		return bank
	var bank : Resource = load(save_file_path)
	return bank

func reset():
	var bank := bank_loaded.new()
	bank.data = {}
	bank.boxes = {}
	bank.parties_order = []
	bank.parties = {}
	bank.folder_path = ""
	var directory : Directory = Directory.new()
	if not directory.dir_exists(BANK_FOLDER):
		directory.make_dir_recursive(BANK_FOLDER)
	var save_path = BANK_FOLDER.plus_file(SAVE_NAME_TEMPLATE)
	var error : int = ResourceSaver.save(save_path,bank)
	if error != OK:
		print("Did not save")
	print("Saved succesfully")
