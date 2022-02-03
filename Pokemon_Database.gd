extends Control

var database = {}
var path = "res://Pokemon_Database.prn"
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

enum damage_class {
	NULL,
	PHYSICAL,
	SPECIAL,
	STATUS
}
func typing(var type): #this translates the types from a string to a number that repersents the type
	var new_type
	match type:
		"—":
			new_type = types.NULL
		"normal":
			new_type = types.NORMAL
		"fire":
			new_type = types.FIRE
		"water":
			new_type = types.WATER
		"grass":
			new_type = types.GRASS
		"electric":
			new_type = types.ELECTRIC
		"ice":
			new_type = types.ICE
		"fighting":
			new_type = types.FIGHTING
		"poison":
			new_type = types.POISON
		"ground":
			new_type = types.GROUND
		"flying":
			new_type = types.FLYING
		"psychic":
			new_type = types.PSYCHIC
		"bug":
			new_type = types.BUG
		"rock":
			new_type = types.ROCK
		"ghost":
			new_type = types.GHOST
		"dark":
			new_type = types.DARK
		"dragon":
			new_type = types.DRAGON
		"steel":
			new_type = types.STEEL
		"fairy":
			new_type = types.FAIRY
	return new_type

func damageClass(var dam_class):
	var new_class
	match dam_class:
		"physical":
			new_class = damage_class.PHYSICAL
		"special":
			new_class = damage_class.SPECIAL
		"status":
			new_class = damage_class.STATUS
	return new_class
