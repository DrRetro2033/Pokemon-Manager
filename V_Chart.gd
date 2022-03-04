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

#89691
func EvSet(info):
	$Stats/HP.setStats(calculateStats(info["hp"],0,0))
	$Stats/Attack.setStats(calculateStats(info["atk"],0,0))
	$Stats/Defense.setStats(calculateStats(info["def"],0,0))
	$Stats/Speed.setStats(calculateStats(info["spe"],0,0))
	$"Stats/Sp Def".setStats(calculateStats(info["spd"],0,0))
	$"Stats/Sp Atk".setStats(calculateStats(info["spa"],0,0))
	var array = setChart()
	$"Stats/Base Vis".set_polygon(array)
	$Stats/HP.setStats(calculateStats(info["hp"],info["iv_hp"] * 2,0))
	$Stats/Attack.setStats(calculateStats(info["atk"], info["iv_atk"] * 2, 0))
	$Stats/Defense.setStats(calculateStats(info["def"], info["iv_def"] * 2, 0))
	$Stats/Speed.setStats(calculateStats(info["spe"], info["iv_spe"] * 2, 0))
	$"Stats/Sp Def".setStats(calculateStats(info["spd"], info["iv_spd"] * 2, 0))
	$"Stats/Sp Atk".setStats(calculateStats(info["spa"], info["iv_spa"] * 2, 0))
	array = setChart()
	$"Stats/IVs Vis".set_polygon(array)
func calculateStats(base,iv,ev):
	var answer = (((2 * base + iv + (ev/4))*100)/100)+5
	return answer

func setChart():
	var array = PoolVector2Array([
		$Stats/HP.get_child(0).position,
		$Stats/Defense.get_child(0).position,
		$Stats/Attack.get_child(0).position,
		$Stats/Speed.get_child(0).position,
		$"Stats/Sp Atk".get_child(0).position,
		$"Stats/Sp Def".get_child(0).position
	])
	return array
