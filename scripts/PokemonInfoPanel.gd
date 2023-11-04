extends WindowDialog


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func open(x):
	var pokemon = Pokemon.pokemon[x]
	window_title = pokemon.nickname
	$Panel.open(x)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_PokemonInfoPanel_popup_hide():
	pass


func _on_PokemonInfoPanel_visibility_changed():
	if not visible:
		queue_free()
