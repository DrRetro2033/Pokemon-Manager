extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var current_window = null
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _input(event):
	if event is InputEventMouseButton:
		if event.get_button_index() == BUTTON_LEFT:
			if current_window != null:
				send_to_front(current_window)
				current_window = null
func entered_window(node):
	print("Ent")
	current_window = node

func exited_window(node):
	print("Ex")
	current_window = node

func send_to_front(node):
	print("Sending "+node.name+" to front.")
	move_child(node,get_child_count()-1)

func _notification(what):
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Windows_child_entered_tree(node):
	if node is WindowDialog:
		node.connect("visibility_changed",self,"send_to_front",[node])
		node.connect("mouse_entered",self,"entered_window",[node])
		node.connect("mouse_exited",self,"exited_window",[node])
	for x in node.get_children():
		if x.has_signal("mouse_entered"):
			x.connect("mouse_entered",self,"entered_window",[node])
			x.connect("mouse_exited",self,"exited_window",[node])
		for y in x.get_children():
			if y.has_signal("mouse_entered"):
				y.connect("mouse_entered",self,"entered_window",[node])
				y.connect("mouse_exited",self,"exited_window",[node])
			for z in y.get_children():
				if z.has_signal("mouse_entered"):
					z.connect("mouse_entered",self,"entered_window",[node])
					z.connect("mouse_exited",self,"exited_window",[node])
