extends Node

const bank_loaded = preload("res://data/bank.gd")
const BANK_FOLDER : String = "res://save"
var SAVE_NAME_TEMPLATE : String = "bank.tres"
var file_exists : bool = false

func save():
	var bank := bank_loaded.new()
	for node in get_tree().get_nodes_in_group("Bank"):
		node.save(bank)
	for item in bank.data:
		var last = bank.data.back()
		if last == null:
			bank.data.remove(bank.data.size() - 1)
		elif last != null:
			break
	var directory : Directory = Directory.new()
	if not directory.dir_exists(BANK_FOLDER):
		directory.make_dir_recursive(BANK_FOLDER)
	
	var save_path = BANK_FOLDER.plus_file(SAVE_NAME_TEMPLATE)
	var error : int = ResourceSaver.save(save_path,bank)
	if error != OK:
		print("Did not save")
	print("Saved succesfully")

func load():
	var save_file_path : String = BANK_FOLDER.plus_file(SAVE_NAME_TEMPLATE)
	var file : File = File.new()
	if not file.file_exists(save_file_path):
		print("Bank file does not exist")
		return
	
	var bank : Resource = load(save_file_path)
	return bank

func reset():
	var bank := bank_loaded.new()
	bank.data = []
	var directory : Directory = Directory.new()
	if not directory.dir_exists(BANK_FOLDER):
		directory.make_dir_recursive(BANK_FOLDER)
	
	var save_path = BANK_FOLDER.plus_file(SAVE_NAME_TEMPLATE)
	var error : int = ResourceSaver.save(save_path,bank)
	if error != OK:
		print("Did not save")
	print("Saved succesfully")
