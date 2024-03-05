extends Panel


export var res = 10
var equations = {
	"erratic":"Oops! This equation is too complex to display!",
	"fast":"(4L³)/5 = EXP",
	"medium-fast":"L³ = EXP",
	"medium":"L³ = EXP",
	"medium-slow":"  (6/5)L³ - 15L² + 100L - 140 = EXP",
	"fluctuating":"Oops! This equation is too complex to display!",
	"slow":"(5L³)/4 = EXP"
}
var rate = "erratic"
var def_rate = ""
var current_exp = 0
var spin_box_ingore_changes = false
var allow_exp_change = false
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

func set_default_def_rate():
	def_rate = rate

func get_beginning_number(text:String):
	var num = ""
	for c in text:
		if c.is_valid_integer():
			num+=c
		else:
			break
	if not num.empty():
		return int(num)
	return false

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

func set_rate(rate):
	match rate:
		"erratic":
			$VBoxContainer/RateSelector.select(0)
		"fast":
			$VBoxContainer/RateSelector.select(1)
		"medium-fast":
			$VBoxContainer/RateSelector.select(2)
		"medium":
			$VBoxContainer/RateSelector.select(3)
		"medium-slow":
			$VBoxContainer/RateSelector.select(4)
		"fluctuating":
			$VBoxContainer/RateSelector.select(5)

func _on_LineEdit_text_changed(new_text):
	spin_box_ingore_changes = true
	var math = ugh_math(new_text)
	print(get_beginning_number(new_text))
	if new_text.empty():
		$VBoxContainer/Control.set_text(equations[rate])
		$VBoxContainer/ExpLine.text = ""
		$VBoxContainer/TextureRect/ProgressBar.value = 0
		$VBoxContainer/HBoxContainer/OptionButton.disabled = true
	elif math != null and str(math).is_valid_integer():
		$VBoxContainer/HBoxContainer/OptionButton.disabled = false
		var text = equations[rate]
		text = text.replace('L','('+str(math)+')')
		text = text.replace("EXP",str(Pokemon.experience(int(str(math)),rate)))
		$VBoxContainer/Control.set_text(text)
		exp_equation(new_text,math)
		$VBoxContainer/TextureRect/ProgressBar.value = int(str(math))
		if int(str(math)) != get_beginning_number(new_text):
			$VBoxContainer/HBoxContainer/SpinBox.value = candy_needed(new_text,math)
		else:
			$VBoxContainer/HBoxContainer/SpinBox.value = 0
	else:
		$VBoxContainer/Control.set_text("Error: Invalid Input")
	spin_box_ingore_changes = false

func exp_equation(new_text,math):
	if int(str(math)) != get_beginning_number(new_text):
		var exp_cal = str(current_exp)
		var type = Pokemon.exp_candy.keys()[$VBoxContainer/HBoxContainer/OptionButton.selected]
		exp_cal+="+("+str(Pokemon.exp_candy[type])+'*'+str(candy_needed(new_text,math))+")"
		$VBoxContainer/ExpLine.text = exp_cal
	else:
		var exp_cal = str(Pokemon.experience(get_beginning_number(new_text),rate))
		$VBoxContainer/ExpLine.text = exp_cal
	if allow_exp_change:
		math = ugh_math($VBoxContainer/ExpLine.text)
		current_exp = math


func candy_needed(new_text,math):
	var type = Pokemon.exp_candy.keys()[$VBoxContainer/HBoxContainer/OptionButton.selected]
	var candy = Pokemon.level_candy_needed(get_beginning_number(new_text),int(str(math)),rate,type)
	return candy

func _on_ExpLine_text_changed(new_text):
	spin_box_ingore_changes = true
	var math = ugh_math(new_text)
	if new_text.empty():
		$VBoxContainer/Control/.set_text(equations[rate])
		$VBoxContainer/LevelLine.text = ""
		$VBoxContainer/TextureRect/ProgressBar.value = 0
		$VBoxContainer/HBoxContainer/OptionButton.disabled = true
	elif math != null and str(math).is_valid_integer():
		$VBoxContainer/HBoxContainer/OptionButton.disabled = false
		var level = str(Pokemon.level(int(math),rate))
		$VBoxContainer/LevelLine.text = level
		var text = equations[rate]
		text = text.replace('L','('+level+')')
		text = text.replace("EXP",str(math))
		$VBoxContainer/Control.set_text(text)
		$VBoxContainer/TextureRect/ProgressBar.value = int(level)
		$VBoxContainer/HBoxContainer/SpinBox.value = 0
		if allow_exp_change:
			current_exp = int(new_text)
	else:
		$VBoxContainer/Control.set_text("Error: Invalid Input")
	spin_box_ingore_changes = false


func _on_Button_pressed():
	match def_rate:
		"erratic":
			$VBoxContainer/RateSelector.select(0)
		"fast":
			$VBoxContainer/RateSelector.select(1)
		"medium-fast":
			$VBoxContainer/RateSelector.select(2)
		"medium":
			$VBoxContainer/RateSelector.select(3)
		"medium-slow":
			$VBoxContainer/RateSelector.select(4)
		"fluctuating":
			$VBoxContainer/RateSelector.select(5)
	rate = def_rate
	set_chart(rate)
	$VBoxContainer/ExpLine.text = str(current_exp)
	$VBoxContainer/ExpLine.emit_signal("text_changed",str(current_exp))
	$VBoxContainer/Control.restart_scroll()


func _on_OptionButton_item_selected(index):
	var math = ugh_math($VBoxContainer/LevelLine.text)
	if int(str(math)) == get_beginning_number($VBoxContainer/LevelLine.text):
		$VBoxContainer/HBoxContainer/SpinBox.value = 0
		return
	spin_box_ingore_changes = true
	exp_equation($VBoxContainer/LevelLine.text,math)
	spin_box_ingore_changes = false
	$VBoxContainer/HBoxContainer/SpinBox.value = candy_needed($VBoxContainer/LevelLine.text,math)


func _on_SpinBox_value_changed(value):
	if spin_box_ingore_changes:
		return
	elif $VBoxContainer/LevelLine.text.empty() and $VBoxContainer/ExpLine.text.empty():
		return
	elif value == 0:
		$VBoxContainer/LevelLine.text = str(get_beginning_number($VBoxContainer/LevelLine.text))
		$VBoxContainer/ExpLine.text = str(get_beginning_number($VBoxContainer/ExpLine.text))
		var text = equations[rate]
		text = text.replace('L','('+$VBoxContainer/LevelLine.text+')')
		text = text.replace("EXP",str($VBoxContainer/ExpLine.text))
		$VBoxContainer/Control.set_text(text)
		$VBoxContainer/TextureRect/ProgressBar.value = int($VBoxContainer/LevelLine.text)
		return
	$VBoxContainer/LevelLine.text = str(Pokemon.level(get_beginning_number($VBoxContainer/ExpLine.text),rate))
	$VBoxContainer/ExpLine.text = str(get_beginning_number($VBoxContainer/ExpLine.text))
	var type = Pokemon.exp_candy.keys()[$VBoxContainer/HBoxContainer/OptionButton.selected]
	$VBoxContainer/ExpLine.text += "+("+str(Pokemon.exp_candy[type])+'*'+str($VBoxContainer/HBoxContainer/SpinBox.value)+")"
	var exp_math = ugh_math($VBoxContainer/ExpLine.text)
	$VBoxContainer/LevelLine.text += "+"+str(abs(int($VBoxContainer/LevelLine.text)-Pokemon.level(int(str(exp_math)),rate)))
	var math = ugh_math($VBoxContainer/LevelLine.text)
	$VBoxContainer/TextureRect/ProgressBar.value = int(str(math))
	math = ugh_math($VBoxContainer/ExpLine.text)
	var text = equations[rate]
	var level = str(Pokemon.level(int(math),rate))
	text = text.replace('L','('+level+')')
	text = text.replace("EXP",str(math))
	$VBoxContainer/Control.set_text(text)


func _on_RateSelector_item_selected(index):
	match index:
		0:
			rate = "erratic"
		1:
			rate = "fast"
		2:
			rate = "medium-fast"
		3:
			rate = "medium"
		4:
			rate = "medium-slow"
		5:
			rate = "fluctuating"
	set_chart(rate)
	$VBoxContainer/ExpLine.text = str(current_exp)
	$VBoxContainer/ExpLine.emit_signal("text_changed",str(current_exp))
	$VBoxContainer/Control.restart_scroll()


func _on_Chart_visibility_changed():
	pass

