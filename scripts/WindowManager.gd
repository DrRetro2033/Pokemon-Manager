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

func entered_window(node): # This fuction and the one preceding it is for when the user
	# clicks on a window behind another window. In most OSs, the window will be sent to the front.
	# Godot on the other hand, does not do this. So these two functions check to see what node is 
	#currently being hovered over.
	current_window = node

func exited_window(node):
	current_window = node

func send_to_front(node): # Sends a window to the front of all other windows
	print("Sending "+node.name+" to front.")
	move_child(node,get_child_count()-1)

func close_all_windows():
	for child in get_children():
		if child is WindowDialog:
			child.hide()

func reorder_right_click_areas(areas:Array): #This function serves two purposes.
	#One, it removes any right click areas that are not visible.
	areas = are_areas_in_hidden_window(areas)
	#Two, it sorts the areas by their parent's child order. 
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
	var children = PM.get_all_children(node)
	for child in children:
		if child.has_signal("mouse_entered"):
			child.connect("mouse_entered",self,"entered_window",[node])
			child.connect("mouse_exited",self,"exited_window",[node])

func sort_areas(a, b): 
	var x = 0
	var y = 0
	while x < get_child_count():
		var window = get_child(x)
		if window.is_a_parent_of(a): #Is this area a child of one of this node's children?
			 break
		x += 1
	if x >= get_child_count(): #If x is greater than the amount of children in this node,
		# then we know that the area is not in any window, so set it's order to 0.
		# Reason? Well if the area is not inside of this node, then it must be from the main bank view.
		# Which means that it's behind all other windows, so it belongs behind all windows.
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
