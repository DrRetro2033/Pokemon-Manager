extends Node
#                  funny   and silly
# Built to destroy f%$&#@! a#$ s%%&%^ garbage characters, also known as stupid characters.
const REPLACE = {
	12:32,
	10:32
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func removeImportNonsense(path):
	path.erase(path.length()-7,7) #removes godots ".import" at the end of a file path.
	return path

func removeEscapechars(text): #removes all escape charaters that messes up the pokedex entries
	var ascii_text = Array(text.to_utf8())
	while ascii_text.has(12):
		var pos = ascii_text.find(12)
		ascii_text.remove(pos)
		ascii_text.insert(pos,32)
	while ascii_text.has(10):
		var pos = ascii_text.find(10)
		ascii_text.remove(pos)
		ascii_text.insert(pos,32)
	text = PoolByteArray(ascii_text).get_string_from_utf8()
	return text
