extends Control

var error_rect = []
var errors = []

func _ready():
	get_child(0).visible = false
	get_tree().root.call_deferred("move_child",self,get_tree().root.get_child_count()-1)

func _process(delta):
	display_warnings()
	yield(VisualServer,"frame_post_draw")

func add_warning(node:Control):
	var error = {
		"error_hash":randi(),
		"node":node.get_path()
	}
	var error_rect : ColorRect = get_child(0).duplicate()
	add_child(error_rect)
	print(node.get_global_rect())
	error_rect.name = str(error.error_hash)
	errors.append(error)

func display_warnings():
	for error in errors:
		if error == null:
			continue
		var node : Control = get_node_or_null(error.node)
		if node == null:
			remove_error_with_hash(error.error_hash)
			break
		var error_rect = get_node(str(error.error_hash))
		if node != null:
			error_rect.rect_global_position = node.get_global_rect().position
			error_rect.rect_size = node.get_global_rect().size
			error_rect.visible = node.visible
	return

func remove_error_with_hash(error_hash:int):
	var x = 0
	while x < errors.size():
		var error = errors[x]
		if error.error_hash == error_hash:
			errors.remove(x)
			get_node(str(error_hash)).queue_free()
			break
		x += 1
	return
