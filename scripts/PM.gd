extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	OS.min_window_size = Vector2(1024,600)
	OS.max_window_size = Vector2(1920,1080)
	get_tree().connect("files_dropped",self,"_on_files_dropped")

func _on_files_dropped(files, screen):
	print(files)
	var array = []
	for path in files:
		match path.get_extension():
			"png":
				var img = Image.new()
				img.load(path)
				array.append(img)
				break
	for file in array:
		get_pokemon_from_img(file)


func get_pokemon_from_img(img : Image):
	var pool = get_pixel_colors_as_pool(img,Rect2(1,img.get_height()-1,4,0))
	print(pool.get_string_from_utf8())
	pool = get_pixel_colors_as_pool(img,Rect2(5,img.get_height()-1,4,0))
	print(pool.get_string_from_utf8())
	pool = get_pixel_colors_as_pool(img,Rect2(10,img.get_height()-1,1,0))
	print(pool)
	var bin = BinaryTranslator.int_to_bin(pool[0]) + BinaryTranslator.int_to_bin(pool[1])
	print(bin)
	print(BinaryTranslator.bin_to_int(BinaryTranslator.invert_binary(bin)))

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
