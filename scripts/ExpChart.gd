extends PopupPanel


export var res = 10
var equations = {
	"fast":"(4L³)/5 = EXP",
	"medium-fast":"L³ = EXP",
	"medium":"L³ = EXP",
	"medium-slow":"  (6/5)L³ - 15L² + 100L - 140 = EXP",
	"slow":"(5L³)/4 = EXP"
}
var rate = ""
var current_exp = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/Control/Label.visible = false

func set_chart(rate):
	var pos = 0
	self.rate = rate
	var max_x = $Viewport.size.x
	var step = max_x/res
	var rate_step = int(98/res)
	$Viewport/Line2D.clear_points()
	while pos < res+1:
		$Viewport/Line2D.add_point(Vector2(step*pos-1,range_lerp(Pokemon.rates[rate][(pos*rate_step)],0,Pokemon.rates[rate][98],max_x,0)))
		pos += 1
	print($Viewport/Line2D.points)
	$VBoxContainer/Control.set_text(equations[rate])


func ugh_math(text:String):
	var expression = Expression.new()
	var error = expression.parse(text)
	if error != OK:
		print(expression.get_error_text())
		return null
	var result = expression.execute()
	if not expression.has_execute_failed():
		return result
	else:
		return null

func _on_Chart_about_to_show():
	set_global_position(get_viewport().get_mouse_position())
	$VBoxContainer/Control.restart_scroll()
	var r_text : String = rate
	r_text = r_text.replace("-"," ")
	$VBoxContainer/Label.text = r_text.capitalize()

func _on_LineEdit_text_changed(new_text):
	var math = ugh_math(new_text)
	if new_text.empty():
		$VBoxContainer/Control.set_text(equations[rate])
		$VBoxContainer/ExpLine.text = ""
		$VBoxContainer/TextureRect/ProgressBar.value = 0
	elif math != null and str(math).is_valid_integer():
		var text = equations[rate]
		text = text.replace('L','('+str(math)+')')
		text = text.replace("EXP",str(Pokemon.experience(int(str(math)),rate)))
		$VBoxContainer/Control.set_text(text)
		$VBoxContainer/ExpLine.text = str(Pokemon.experience(int(str(math)),rate))
		$VBoxContainer/TextureRect/ProgressBar.value = int(str(math))
	else:
		$VBoxContainer/Control.set_text("Error: Invalid Input")


func _on_ExpLine_text_changed(new_text):
	var math = ugh_math(new_text)
	if new_text.empty():
		$VBoxContainer/Control/.set_text(equations[rate])
		$VBoxContainer/LevelLine.text = ""
		$VBoxContainer/TextureRect/ProgressBar.value = 0
	elif math != null and str(math).is_valid_integer():
		var level = str(Pokemon.level(int(math),rate))
		$VBoxContainer/LevelLine.text = level
		var text = equations[rate]
		text = text.replace('L','('+level+')')
		text = text.replace("EXP",str(math))
		$VBoxContainer/Control.set_text(text)
		$VBoxContainer/TextureRect/ProgressBar.value = int(level)
	else:
		$VBoxContainer/Control.set_text("Error: Invalid Input")


func _on_Button_pressed():
	$VBoxContainer/ExpLine.text = str(current_exp)
	$VBoxContainer/ExpLine.emit_signal("text_changed",str(current_exp))
