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

func reorder_right_click_areas(areas:Array):
	areas = are_areas_in_hidden_window(areas)
	areas.sort_custom(self,"sort_areas")
	return areas
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func are_areas_in_hidden_window(areas:Array):
	var valid_areas = []
	for area in areas:
		var valid = true
		var current_node = area
		while true:
			var parent = current_node.get_parent()
			if parent == self or parent.is_a_parent_of(self):
				break
			if parent is Control:
				if not parent.visible:
					valid = false
					break
			current_node = parent
		if valid:
			valid_areas.append(area)
	return valid_areas

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

func sort_areas(a, b):
	var x = 0
	var y = 0
	while x < get_child_count():
		var window = get_child(x)
		if window.is_a_parent_of(a):
			 break
		x += 1
	if x >= get_child_count():
		x = 0
	while y < get_child_count():
		var window = get_child(y)
		if window.is_a_parent_of(b):
			 break
		y += 1
	if y >= get_child_count():
		y = 0
	
	if x > y:
		return true
	return false
