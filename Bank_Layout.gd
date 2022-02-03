extends TabContainer

onready var box = load("res://Box.tscn")
var page = 0
var max_per_page = 15

func addPokemon(pokemon):
	var overflow = int(pokemon.size() / max_per_page)
	print(overflow)
	while overflow > 0:
		var new_box = box.instance()
		add_child(new_box)
		yield(get_tree().create_timer(1),"timeout")
		overflow -= 1
	var current_pos = pokemon
	for x in get_children():
		current_pos = x.setSlots(current_pos)
		yield(get_tree().create_timer(0.1),"timeout")
	$"../Loading Screen".visible = false

func dragSwitch(pos):
	set_current_tab(get_tab_idx_at_point(pos))
