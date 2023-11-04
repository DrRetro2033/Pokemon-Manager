extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal item_selected(id)
export var items : Array = []
export var is_active : bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	if $CollisionShape2D.position != get_parent().get_global_rect().size/2 and visible:
		var shape : RectangleShape2D = RectangleShape2D.new()
		shape.extents = get_parent().get_global_rect().size/2
		$CollisionShape2D.shape = shape
		$CollisionShape2D.position = get_parent().get_global_rect().size/2

func is_usable():
	return is_active

func get_items():
	return items

func item_selected(id):
	emit_signal("item_selected",id)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_VisibilityNotifier2D_viewport_entered(viewport):
	print(name+" is true")


func _on_VisibilityNotifier2D_viewport_exited(viewport):
	print(name+" is false")



func _on_VisibilityNotifier2D_visibility_changed():
	print(name+" is "+str($VisibilityNotifier2D.visible))
