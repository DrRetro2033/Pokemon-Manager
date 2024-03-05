extends Window

onready var bank = get_tree().root.get_node("/root/BankManager")
const settings_path = "user://save/"
var play_image
var stop_image
var background_music_files = []
const warning = "Resetting Pokémon Manager means deleting all Trainers, Parties, and other changes to the program. Your Pokémon in the pkmdb folder will remain intact and will be safe. \n\n Are you sure you want to continue?"
onready var filter = $ScrollContainer/VBoxContainer/Search/HBoxContainer2/Filter
onready var tag = $ScrollContainer/VBoxContainer/Search/HBoxContainer2/Tag
onready var volume_slider_background_music = $ScrollContainer/VBoxContainer/General/HBoxContainer4/HSlider
onready var always_ask_to_save_checkbox = $ScrollContainer/VBoxContainer/General/SaveChanges
onready var background_music_dropdown = $ScrollContainer/VBoxContainer/General/HBoxContainer3/OptionButton
onready var background_music_play_button = $ScrollContainer/VBoxContainer/General/HBoxContainer3/Button
onready var volume_icon_start_up = $ScrollContainer/VBoxContainer/General/HBoxContainer4/TextureRect
onready var drag_delay_slider = $ScrollContainer/VBoxContainer/General/DragDelay/DragDelaySlider
onready var drag_delay_label = $ScrollContainer/VBoxContainer/General/DragDelay/Label
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$ScrollContainer.scroll_vertical = 0
	play_image = load("res://sprites/ui/icons/play.png")
	stop_image = load("res://sprites/ui/icons/stop.png")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Reset_pressed():
	$NativeDialogMessage.set_text(warning)
	$NativeDialogMessage.show()


func _on_NativeDialogMessage_result_selected(result):
	print(result)
	match result:
		0:
			bank.reset()
			get_tree().quit()
		1:
			pass


func refresh_settings():
	refresh_music_choices()
	filter.set_pressed_no_signal(ProjectSettings.get_setting("Settings/Search/use_filter"))
	tag.set_pressed_no_signal(ProjectSettings.get_setting("Settings/Search/use_tags"))
	volume_slider_background_music.value = ProjectSettings.get_setting("Settings/General/start_up_background_music_volume")*100
	$ScrollContainer/VBoxContainer/General/HBoxContainer4/Label.text = str(ProjectSettings.get_setting("Settings/General/start_up_background_music_volume")*100)
	drag_delay_slider.value = ProjectSettings.get_setting("Settings/General/hover_time_to_switch_tabs")
	drag_delay_label.text = str(ProjectSettings.get_setting("Settings/General/hover_time_to_switch_tabs"))+" Seconds"
	always_ask_to_save_checkbox.set_pressed_no_signal(ProjectSettings.get_setting("Settings/General/always_ask_to_save"))

func _on_Tag_toggled(button_pressed):
	pass


func _on_Settings_about_to_show():
	refresh_settings()


func _on_Filter_toggled(button_pressed):
	pass


func _on_Cancel_pressed():
	background_music_play_button.pressed = false
	hide()


func _on_Apply_pressed():
	ProjectSettings.set_setting("Settings/Search/use_tags",tag.pressed)
	ProjectSettings.set_setting("Settings/Search/use_filter",filter.pressed)
	ProjectSettings.set_setting("Settings/General/always_ask_to_save",always_ask_to_save_checkbox.pressed)
	ProjectSettings.set_setting("Settings/General/start_up_background_music_volume",volume_slider_background_music.value/100)
	ProjectSettings.set_setting("Settings/General/hover_time_to_switch_tabs",drag_delay_slider.value)
	var music = ""
	if background_music_dropdown.selected == 0:
		music = "rando"
	else:
		music = background_music_files[background_music_dropdown.selected-1]
	ProjectSettings.set_setting("Settings/General/start_up_background_music_name",music)
	background_music_play_button.pressed = false
	PM.save_settings()
	hide()

func refresh_music_choices():
	background_music_dropdown.clear()
	var files = []
	var dir1 = Directory.new()
	dir1.open("res://sound/startup_background_music/")
	dir1.list_dir_begin()
	while true:
		var file = dir1.get_next()
		if file == "":
			break
		files.append(file)
	dir1.list_dir_end()
	background_music_dropdown.add_item("Random")
	print(files)
	for path in files:
		var mus_name = ""
		if str(path) == '.' or str(path) == '..':
			continue
		elif not str(path).ends_with(".import"):
			background_music_files.append("res://sound/startup_background_music/"+path)
			mus_name = path.get_basename()
		else:
#			background_music_files.append(StupidCharacters.removeImportNonsense("res://sound/startup_background_music/"+path))
			mus_name = StupidCharacters.removeImportNonsense(path).get_basename()
		if not background_music_dropdown.items.has(mus_name):
			background_music_dropdown.add_item(mus_name)
	if background_music_files.has(ProjectSettings.get_setting("Settings/General/start_up_background_music_name")):
		var x = background_music_files.find(ProjectSettings.get_setting("Settings/General/start_up_background_music_name"))
		background_music_dropdown.select(x+1)
		$AudioStreamPlayer.stream = load(background_music_files[x])
	else:
		background_music_dropdown.select(0)

func _on_HSlider_drag_started():
	background_music_play_button.pressed = true


func _on_HSlider_value_changed(value):
	$ScrollContainer/VBoxContainer/General/HBoxContainer4/Label.text = str(value)
	if value > 0:
		$AudioStreamPlayer.volume_db = lerp(-30,0,value/100)
	else:
		$AudioStreamPlayer.volume_db = -120
	if value > 50:
		volume_icon_start_up.texture = load("res://sprites/ui/icons/volume_up.png")
	elif value > 0:
		volume_icon_start_up.texture = load("res://sprites/ui/icons/volume_down.png")
	else:
		volume_icon_start_up.texture = load("res://sprites/ui/icons/volume_mute.png")

func _on_HSlider_drag_ended(value_changed):
	pass


func _on_SaveChanges_toggled(button_pressed):
	pass


func _on_Button_toggled(button_pressed):
	if button_pressed:
		background_music_play_button.icon = stop_image
		$AudioStreamPlayer.stop()
		if background_music_dropdown.selected == 0:
			var rand = RandomNumberGenerator.new()
			rand.randomize()
			$AudioStreamPlayer.stream = load(background_music_files[rand.randi_range(0,background_music_files.size()-1)])
		$AudioStreamPlayer.play(0.0)
	else:
		$AudioStreamPlayer.stop()
		background_music_play_button.icon = play_image


func _on_OptionButton_item_selected(index):
	print(background_music_files)
	if index == 0:
		background_music_play_button.pressed = false
		$AudioStreamPlayer.stop()
		var rand = RandomNumberGenerator.new()
		rand.randomize()
		$AudioStreamPlayer.stream = load(background_music_files[rand.randi_range(0,background_music_files.size()-1)])
		background_music_play_button.pressed = true
	else:
		background_music_play_button.pressed = false
		$AudioStreamPlayer.stop()
		$AudioStreamPlayer.stream = load(background_music_files[index-1])
		background_music_play_button.pressed = true


func _on_Settings_popup_hide():
	background_music_play_button.pressed = false
	hide()


func _on_Reset_Settings_pressed():
	PM.reset_settings()
	refresh_settings()

func dialog_listener(value):
	match str(value):
		"done":
			print(Dialogic.get_variable("have_tutorial"))
			match Dialogic.get_variable("have_tutorial"):
				"True":
					Trainer.have_tutorial = true
				"true":
					Trainer.have_tutorial = true
				"False":
					Trainer.have_tutorial = false 
				"false":
					Trainer.have_tutorial = false

func _on_Button_pressed():
	var new_dialog = Dialogic.start("Tutorial")
	get_tree().root.get_node("Control").add_child(new_dialog)
	get_tree().root.get_node("Control").move_child(new_dialog,get_tree().root.get_node("Control").get_child_count()-1)
	new_dialog.set_layer(3)
	new_dialog.connect("dialogic_signal", self, "dialog_listener")
	get_parent().close_all_windows()
	Trainer.reset_tutorials()


func _on_DragDelaySlider_value_changed(value):
	drag_delay_label.text = str(value)+" Seconds"
