extends Path2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func setStats(stat):
	print(stat)
	var dis = float(float(stat)/float(255))
	print(dis)
	get_child(0).set_unit_offset(1 * dis)
