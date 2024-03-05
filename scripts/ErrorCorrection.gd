extends Node2D

var error_rect = []
var errors = []

func _ready():
	z_index = 1

func check_for_errors(array):
	var report = ErrorReport.new()
	if array.species == 0:
		report.set_check(ErrorReport.Checks.SPECIES,ErrorReport.FAILED)
	else:
		report.set_check(ErrorReport.Checks.SPECIES,ErrorReport.PASSED)
	
	var error_in_moves = false
	#Move 1 Check
	if array.move1 == 0:
		report.set_check(ErrorReport.Checks.MOVE_1,ErrorReport.FAILED)
		error_in_moves = true
	else:
		report.set_check(ErrorReport.Checks.MOVE_1,ErrorReport.PASSED)
	
	#Move 2 Check
	if array.move2 == 0:
		report.set_check(ErrorReport.Checks.MOVE_2,ErrorReport.FAILED)
		error_in_moves = true
	else:
		report.set_check(ErrorReport.Checks.MOVE_2,ErrorReport.PASSED)
	
	#Move 3 Check
	if array.move3 == 0:
		report.set_check(ErrorReport.Checks.MOVE_3,ErrorReport.FAILED)
		error_in_moves = true
	else:
		report.set_check(ErrorReport.Checks.MOVE_3,ErrorReport.PASSED)

	#Move 4 Check
	if array.move4 == 0:
		report.set_check(ErrorReport.Checks.MOVE_4,ErrorReport.FAILED)
		error_in_moves = true
	else:
		report.set_check(ErrorReport.Checks.MOVE_4,ErrorReport.PASSED)

	if error_in_moves:
		report.set_check(ErrorReport.Checks.MOVES,ErrorReport.FAILED)
	else:
		report.set_check(ErrorReport.Checks.MOVES,ErrorReport.PASSED)
	return report

func add_warning(node:Control):
	errors.append(node)

func _process(delta):
	pass


func _draw():
	for node in errors:
		display_warning(node)

func display_warning(node:Control):
	var color = Color.red
	color.a = 0.2
	var rect = node.get_rect()
	rect.position = node.rect_global_position
	draw_rect(rect,color)

class ErrorReport:
	enum {
		PASSED,
		FAILED
	}
	enum Checks {
		SPECIES,
		MOVES,
		MOVE_1,
		MOVE_2,
		MOVE_3,
		MOVE_4
	}
	var report = {}

	func set_check(check:int,status:int):
		report[check] = status
	
	func check_passed(check:int):
		if report[check] == PASSED:
			return true
		return false
