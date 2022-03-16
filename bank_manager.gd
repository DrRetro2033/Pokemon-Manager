extends Node

const bank_loaded = preload("res://data/bank.gd")
const BANK_FOLDER : String = "res://save"
var SAVE_NAME_TEMPLATE : String = "bank.tres"
var file_exists : bool = false

func save():
	var bank := bank_loaded.new()
	for node in get_tree().get_nodes_in_group("Bank"):
		node.save(bank)
	for item in bank.order:
		var last = bank.order.back()
		if last == null:
			bank.order.remove(bank.order.size() - 1)
		elif last != null:
			break
	$"../TabContainer".save(bank)
	bank.data = Pokemon.pokemon
	Trainer.save(bank)
	var path : String = OS.get_executable_path().get_base_dir()+"/save"
	print(path)
	var save_file_path : String
	if path == "C:/Program Files (x86)/Steam/steamapps/common/Godot Engine/save":
		var directory : Directory = Directory.new()
		if not directory.dir_exists(BANK_FOLDER):
			directory.make_dir_recursive(BANK_FOLDER)
		
		var save_path = BANK_FOLDER.plus_file(SAVE_NAME_TEMPLATE)
		var error : int = ResourceSaver.save(save_path,bank)
		if error != OK:
			print("Did not save")
		print("Saved succesfully")
	else:
		var directory : Directory = Directory.new()
		if not directory.dir_exists(path):
			directory.make_dir_recursive(path)
		
		var save_path = path.plus_file(SAVE_NAME_TEMPLATE)
		var error : int = ResourceSaver.save(save_path,bank)
		if error != OK:
			print("Did not save")
		print("Saved succesfully")

func load():
	var path : String = OS.get_executable_path().get_base_dir()+"/save"
	print(path)
	var save_file_path : String
	if path == "C:/Program Files (x86)/Steam/steamapps/common/Godot Engine/save":
		save_file_path = BANK_FOLDER.plus_file(SAVE_NAME_TEMPLATE)
		var file : File = File.new()
		if not file.file_exists(save_file_path):
			print("Bank file does not exist")
			var bank = []
			return bank
	else:
		save_file_path = path.plus_file(SAVE_NAME_TEMPLATE)
		var file : File = File.new()
		if not file.file_exists(save_file_path):
			print("Bank file does not exist")
			var bank = []
			return bank
	var bank : Resource = load(save_file_path)
	return bank

func reset():
	var bank := bank_loaded.new()
	bank.data = {}
	bank.order = []
	bank.box_names = []
	var directory : Directory = Directory.new()
	if not directory.dir_exists(BANK_FOLDER):
		directory.make_dir_recursive(BANK_FOLDER)
	
	var save_path = BANK_FOLDER.plus_file(SAVE_NAME_TEMPLATE)
	var error : int = ResourceSaver.save(save_path,bank)
	if error != OK:
		print("Did not save")
	print("Saved succesfully")
