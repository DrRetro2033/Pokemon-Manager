extends WindowDialog
var pic

func _ready():
	pass # Replace with function body.

func _on_Button_pressed():
	if $Name.text == "":
		$Warning.visible = true
	else:
		Trainer.trainer_name = $Name.text
		Trainer.trainer_picture = pic
		$"../ProfilePic/Pic".texture = pic
		visible = false

func _on_ProfilePic_pressed():
	$"../FileDialog".popup()


func _on_FileDialog_file_selected(path):
	var img = Image.new()
	img.load(path)
	var tex = ImageTexture.new()
	tex.create_from_image(img)
	pic = tex
	$ProfilePic/Pic.texture = tex
