extends GridContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func moves(var info):
	var moves = 4
	while moves > 0:
		var move = info[1][3][moves - 1]
		var child = get_child(moves - 1)
		child.move(move[0],move[1],move[2],move[3],move[4])
		moves - 1
