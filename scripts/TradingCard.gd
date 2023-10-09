extends Viewport


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
enum types {
	NULL,
	NORMAL,
	FIRE,
	WATER,
	GRASS,
	ELECTRIC,
	ICE,
	FIGHTING,
	POISON,
	GROUND,
	FLYING,
	PSYCHIC,
	BUG,
	ROCK,
	GHOST,
	DARK,
	DRAGON,
	STEEL,
	FAIRY
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func types(var type, var node):
	var style = node.get_stylebox("panel").duplicate()
	match type: #sets the text and color for the type2
		types.NULL:
			$PanelContainer/VBoxContainer/TopRow/PanelContainer/PanelContainer/Panel/VBoxContainer/Types.text += ""
			style.set_bg_color(Color8(66,66,66,255))
		types.NORMAL:
			$PanelContainer/VBoxContainer/TopRow/PanelContainer/PanelContainer/Panel/VBoxContainer/Types.text += "c"
			style.set_bg_color(Color("#c3c2a4"))
		types.FIRE:
			$PanelContainer/VBoxContainer/TopRow/PanelContainer/PanelContainer/Panel/VBoxContainer/Types.text += "r"
			style.set_bg_color(Color("#df2c04"))
		types.WATER:
			$PanelContainer/VBoxContainer/TopRow/PanelContainer/PanelContainer/Panel/VBoxContainer/Types.text += "w"
			style.set_bg_color(Color("#3578f4"))
		types.GRASS:
			$PanelContainer/VBoxContainer/TopRow/PanelContainer/PanelContainer/Panel/VBoxContainer/Types.text += "g"
			style.set_bg_color(Color("#57a031"))
		types.ELECTRIC:
			$PanelContainer/VBoxContainer/TopRow/PanelContainer/PanelContainer/Panel/VBoxContainer/Types.text += "l"
			style.set_bg_color(Color("#f8c81d"))
		types.ICE:
			$PanelContainer/VBoxContainer/TopRow/PanelContainer/PanelContainer/Panel/VBoxContainer/Types.text += "i"
			style.set_bg_color(Color("#81e0e5"))
		types.FIGHTING:
			$PanelContainer/VBoxContainer/TopRow/PanelContainer/PanelContainer/Panel/VBoxContainer/Types.text += "f"
			style.set_bg_color(Color("#6d2818"))
		types.POISON:
			$PanelContainer/VBoxContainer/TopRow/PanelContainer/PanelContainer/Panel/VBoxContainer/Types.text += "o"
			style.set_bg_color(Color("#9345b3"))
		types.GROUND:
			$PanelContainer/VBoxContainer/TopRow/PanelContainer/PanelContainer/Panel/VBoxContainer/Types.text += "a"
			style.set_bg_color(Color("#d1b85e"))
		types.FLYING:
			$PanelContainer/VBoxContainer/TopRow/PanelContainer/PanelContainer/Panel/VBoxContainer/Types.text += "v"
			style.set_bg_color(Color("#84afff"))
		types.PSYCHIC:
			$PanelContainer/VBoxContainer/TopRow/PanelContainer/PanelContainer/Panel/VBoxContainer/Types.text += "p"
			style.set_bg_color(Color("#ff398b"))
		types.BUG:
			$PanelContainer/VBoxContainer/TopRow/PanelContainer/PanelContainer/Panel/VBoxContainer/Types.text += "b"
			style.set_bg_color(Color("#bdc45b"))
		types.ROCK:
			$PanelContainer/VBoxContainer/TopRow/PanelContainer/PanelContainer/Panel/VBoxContainer/Types.text += "k"
			style.set_bg_color(Color("#b29e59"))
		types.GHOST:
			$PanelContainer/VBoxContainer/TopRow/PanelContainer/PanelContainer/Panel/VBoxContainer/Types.text += "h"
			style.set_bg_color(Color("#5d66a6"))
		types.DARK:
			$PanelContainer/VBoxContainer/TopRow/PanelContainer/PanelContainer/Panel/VBoxContainer/Types.text += "d"
			style.set_bg_color(Color("#442d04"))
		types.DRAGON:
			$PanelContainer/VBoxContainer/TopRow/PanelContainer/PanelContainer/Panel/VBoxContainer/Types.text += "n"
			style.set_bg_color(Color("#8c79dc"))
		types.STEEL:
			$PanelContainer/VBoxContainer/TopRow/PanelContainer/PanelContainer/Panel/VBoxContainer/Types.text += "m"
			style.set_bg_color(Color("#b7b7ce"))
		types.FAIRY:
			$PanelContainer/VBoxContainer/TopRow/PanelContainer/PanelContainer/Panel/VBoxContainer/Types.text += "y"
			style.set_bg_color(Color("#f0aee1"))
	node.add_stylebox_override("panel",style)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func set_card(info):
	$PanelContainer/VBoxContainer/Sprite.texture = load("res://sprites/pokemon/official-artwork/"+info.sprite)
	$PanelContainer/VBoxContainer/TopRow/Name.text = info.nickname
	$"PanelContainer/VBoxContainer/OT Trainer".text = info.ot.nickname
	types(info.type1,$PanelContainer/VBoxContainer/TopRow/PanelContainer/PanelContainer/Panel/Type1)
	if info.type2 == types.NULL:
		$PanelContainer/VBoxContainer/TopRow/PanelContainer/PanelContainer/Panel/Type2.visible = false
	types(info.type2,$PanelContainer/VBoxContainer/TopRow/PanelContainer/PanelContainer/Panel/Type2)

func set_code(code:PoolColorArray):
#	var texture : GradientTexture2D = $PanelContainer/VBoxContainer/TextureRect.texture.duplicate()
#	var code_size = code.size()
#	var x = 0
#	var gap = 1/float(code_size)
#	print("Gap Between Colors: "+str(gap))
#	texture.gradient.colors = code
#	while x < code_size:
#		texture.gradient.offsets[x] = clamp((gap*x),0,1)
#		x += 1
#	$PanelContainer/VBoxContainer/TextureRect.texture = texture
	pass

func set_bars(array:Array):
	var text = ""
	for y in array:
		for x in y:
			text += str(x)
	$PanelContainer/VBoxContainer/Barcode.text = text

func get_card():
	var viewport_tex = get_texture().get_data()
	return viewport_tex
