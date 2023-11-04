extends KinematicBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var nav_mesh_path : NodePath
var rand = RandomNumberGenerator.new()
var dir : Vector3 = Vector3.ZERO
var min_dir_time = 1.5
var max_dir_time = 2.0
var speed = 0.5
# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.start(0.001)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	var velo = dir*speed
	velo.y = -2
	move_and_slide(velo,Vector3.UP)

func _on_Timer_timeout():
	rand.randomize()
	dir = Vector3(rand.randf_range(-1,1),0,0)
	rand.randomize()
	dir.z = rand.randf_range(-1,1)
	$Timer.start(rand.randf_range(min_dir_time,max_dir_time))
	if dir.x < 0:
		get_tree().create_tween().tween_property($Sprite3D,"rotation:y",deg2rad(0),0.5)
	elif dir.x > 0:
		get_tree().create_tween().tween_property($Sprite3D,"rotation:y",deg2rad(-180),0.5)
