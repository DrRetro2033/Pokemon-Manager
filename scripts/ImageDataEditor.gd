extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var data = {}
const blocks = [
	"IHDR",
	"PLTE",
]
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func extract_image_file_into_data(path:String):
	var file = File.new()
	file.open(path,File.READ_WRITE)
	var data : PoolByteArray = []
	while not file.eof_reached():
		var line = file.get_line()
		if line.find("IDAT") >= 0:
			break
	print(file.get_position())
	var x = file.get_position()
	file.seek(0)
	print(file.get_buffer(x))


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
