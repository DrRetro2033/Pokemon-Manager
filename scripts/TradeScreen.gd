extends Panel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var new_trainer = load("res://scenes/NetworkTrainer.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().connect("network_peer_connected", self,"_player_connected")
	get_tree().connect("network_peer_disconnected", self,"_player_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_to_server")
	$Connecting/Label.text = Trading.ip_address

func _player_connected(id) -> void:
	instance_trainer({"name":Trainer.trainer_name,"pic":Trainer.trainer_picture},id)
	print("Player "+str(id)+" has connected")

func _player_disconnected(id) -> void:
	print("Player "+str(id)+" has disconnected")

func _connected_to_server() -> void:
	instance_trainer({"name":Trainer.trainer_name,"pic":Trainer.trainer_picture},get_tree().get_network_unique_id())

func _on_Create_Server_pressed():
	$Connecting.visible = false
	Trading.create_server()
	instance_trainer({"name":Trainer.trainer_name,"pic":Trainer.trainer_picture},get_tree().get_network_unique_id())


func _on_Join_Server_pressed():
	if $Connecting/IP_Address.text != "":
		$Connecting.visible = false
		Trading.ip_address = $Connecting/IP_Address.text
		Trading.join_server()

func instance_trainer(info,id):
	var trainer_instance = new_trainer.instance()
	print("Player "+str(info["name"])+" has connected")
	trainer_instance.profile_name = info["name"]
	trainer_instance.profile_pic = info["pic"]
	trainer_instance.set_network_master(id)
	$Trainers.add_child(trainer_instance)
	listTrainers()

func listTrainers():
	var text = ""
	print(get_tree().get_network_connected_peers())
	for trainer in get_tree().get_network_connected_peers():
		var node = get_node(str(trainer))
		text += node.profile_name+"\n"
	$Trainer/RichTextLabel.text = text
