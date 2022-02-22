extends Polygon2D

enum stats {
	HP,
	ATK,
	DEF,
	SPE,
	SP_DEF,
	SP_ATK,
	VIS
}
onready var ev = $EV
func _ready():
	pass # Replace with function body.


func EvSet(info):
	$BaseStats/HP.setStats(info["hp"])
	$BaseStats/Attack.setStats(info["atk"])
	$BaseStats/Defense.setStats(info["def"])
	$BaseStats/Speed.setStats(info["spe"])
	$"BaseStats/Sp Def".setStats(info["spd"])
	$"BaseStats/Sp Atk".setStats(info["spa"])
	
	var array = PoolVector2Array([
		$BaseStats/HP.get_child(0).position,
		$BaseStats/Defense.get_child(0).position,
		$BaseStats/Attack.get_child(0).position,
		$BaseStats/Speed.get_child(0).position,
		$"BaseStats/Sp Atk".get_child(0).position,
		$"BaseStats/Sp Def".get_child(0).position
	])
	
	$"BaseStats/EV Vis".set_polygon(array)
	
	
	
	
	
