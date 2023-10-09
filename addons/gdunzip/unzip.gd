var storage_path
var zip_file

func unzip(sourceFile,destination):
	zip_file = sourceFile
	storage_path = destination
	
	var gdunzip = load('res://addons/gdunzip/gdunzip.gd').new()
	var loaded = gdunzip.load(zip_file)

	if !loaded:
		print('- Failed loading zip file')
		return false
		
	ProjectSettings.load_resource_pack(zip_file)
	
	var i = 0
	for f in gdunzip.files:
		unzip_file(f)

func unzip_file(fileName):
	var readFile = File.new()
	readFile.open((fileName), File.READ)
	var content = readFile.get_buffer(readFile.get_len())
	readFile.close()
	
	var base_dir = fileName.get_base_dir()
	
	var dir = Directory.new()
	dir.make_dir(base_dir)
	
	var writeFile = File.new()
	writeFile.open(fileName, File.WRITE)
	print(content)
	writeFile.store_buffer(content)
	writeFile.close()
