extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var speed : float
var default_pos = Vector2(0,0)
var default_size = Vector2(0,0)
var default_min_size = Vector2(0,0)
signal next
var restart_scroll = false
var font : DynamicFont = load("res://fonts/dynamic/ExpChart.tres")
var label : Label
# Called when the node enters the scene tree for the first time.
func _ready():
	default_pos = $Label.rect_position
	default_size = $Label.rect_size
	default_min_size = $Label.rect_min_size
	
func set_text(text):
	if label != null:
		label.queue_free()
	label = $Label.duplicate()
	add_child(label)
	label.text = text
	label.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if label != null:
		scroll()

func scroll():
	set_process(false)
	if label.rect_size.x <= rect_size.x:
		restart_scroll = false
		set_process(true)
		return
	label.rect_position.x -= 1
#	print("SCROLL FOR PETE'S SAKES")
	if abs(label.rect_position.x) + rect_size.x >= label.rect_size.x:
		print(label.rect_size.x)
		print(label.rect_position)
		print(label.rect_size)
		yield(get_tree().create_timer(1.5),"timeout")
		while label.self_modulate.a > 0:
			print(label.self_modulate.a)
			label.self_modulate.a -= 0.01
			yield(get_tree().create_timer(0.01),"timeout")
			if label.self_modulate.a <= 0:
				break
			elif restart_scroll:
				label.self_modulate.a = 1
				label.rect_position = default_pos
				yield(get_tree().create_timer(1.5),"timeout")
				restart_scroll = false
				set_process(true)
				return
		label.rect_position = default_pos
		yield(get_tree().create_timer(0.5),"timeout")
		while label.self_modulate.a < 1:
			print(label.self_modulate.a)
			label.self_modulate.a += 0.01
			yield(get_tree().create_timer(0.01),"timeout")
			if label.self_modulate.a > 1:
				break
			elif restart_scroll:
				label.self_modulate.a = 1
				label.rect_position = default_pos
				yield(get_tree().create_timer(1.5),"timeout")
				restart_scroll = false
				set_process(true)
				return
		yield(get_tree().create_timer(1.5),"timeout")
	yield(get_tree().create_timer(0.1),"timeout")
	if restart_scroll:
		label.self_modulate.a = 1
		label.rect_position = default_pos
		yield(get_tree().create_timer(1),"timeout")
		restart_scroll = false
		set_process(true)
		return
	set_process(true)

func restart_scroll():
	restart_scroll = true
	if scroll() != null:
		scroll().resume()

