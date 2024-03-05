extends Window


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal finished_opening

class_name PokemonInfoWindow

var current_pokemon_id

# Called when the node enters the scene tree for the first time.
func _ready():
	var but = get_close_button().duplicate()
	but.rect_position.x -= 20
	but.rect_min_size = but.rect_size
	but.texture_normal = load("res://sprites/ui/icons/minmize.png")
	but.texture_hover = load("res://sprites/ui/icons/minmize.png")
	but.texture_pressed = load("res://sprites/ui/icons/minmize.png")
	but.expand = true
	but.connect("pressed",self,"minmize")
	get_close_button().get_parent().add_child(but)

func open(x):
	var pokemon = Pokemon.pokemon[x]
	current_pokemon_id = x
	window_title = pokemon.nickname
	$Panel.open(x)
	emit_signal("finished_opening")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_PokemonInfoPanel_popup_hide():
	pass


func _on_PokemonInfoPanel_visibility_changed():
	if not visible:
		queue_free()
