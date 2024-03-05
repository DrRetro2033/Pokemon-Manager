extends Control

signal window_added(window_manager)
var current_window = null
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
	# Godot on the other hand, does not do this. So these two functions set and what node is 
	# currently being hovered over.
	if current_window != null:
		yield(VisualServer,"frame_post_draw")
	current_window = node

func exited_window():
	current_window = null

func send_to_front(node): # Sends a window to the front of all other windows
	print("Sending "+node.name+" to front.")
	move_child(node,get_child_count()-1)

func close_all_windows():
	for child in get_children():
		if child is WindowDialog:
			child.hide()

func reorder_right_click_areas(areas:Array): #This function serves two purposes.
	#One, it removes any right click areas that are not visible in "areas".
	areas = are_areas_in_hidden_window(areas)
	#Two, it sorts "areas" by every node's parent's child order. 
	areas.sort_custom(self,"sort_areas")
	return areas

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
	emit_signal("window_added",self)
	if node is WindowDialog:
		node.connect("visibility_changed",self,"send_to_front",[node])
		node.connect("mouse_entered",self,"entered_window",[node])
		node.connect("mouse_exited",self,"exited_window")
		node.connect("minmize",self,"minmize_window")
	var children = PM.get_all_children(node)
	for child in children:
		if child.has_signal("mouse_entered"):
			child.connect("mouse_entered",self,"entered_window",[node])
			child.connect("mouse_exited",self,"exited_window")

func minmize_window(window:Window):
	window.rect_global_position = OS.get_screen_size()+Vector2(99999,99999)

func sort_areas(a, b): 
	var x = 0
	var y = 0
	while x < get_child_count():
		var window = get_child(x)
		if window.is_a_parent_of(a): #Is this area a child of one of "Windows" children?
			 break
		x += 1
	if x >= get_child_count(): #If x is greater than the amount of children in this node,
		# then we know that the area is not in any window, so set it's order to 0.
		# The Reason? Well, if the area is not inside of "Windows", then it must be from the main bank view.
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
