extends Node

class_name ErrorReport
#This is an error report of pokemon, and makes sure that they are not broken.
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
func check_for_errors(array):
	if array.species == 0:
		set_check(Checks.SPECIES,FAILED)
	else:
		set_check(Checks.SPECIES,PASSED)
	
	var error_in_moves = false
	#Move 1 Check
	if array.move1 is int and array.move1 == 0:
		set_check(Checks.MOVE_1,FAILED)
		error_in_moves = true
	else:
		set_check(Checks.MOVE_1,PASSED)
	
	#Move 2 Check
	if array.move2 is int and array.move2 == 0:
		set_check(Checks.MOVE_2,FAILED)
		error_in_moves = true
	else:
		set_check(Checks.MOVE_2,PASSED)
	
	#Move 3 Check
	if array.move3 is int and array.move3 == 0:
		set_check(Checks.MOVE_3,FAILED)
		error_in_moves = true
	else:
		set_check(Checks.MOVE_3,PASSED)

	#Move 4 Check
	if array.move4 is int and array.move4 == 0:
		set_check(Checks.MOVE_4,FAILED)
		error_in_moves = true
	else:
		set_check(Checks.MOVE_4,PASSED)

	if error_in_moves:
		set_check(Checks.MOVES,FAILED)
	else:
		set_check(Checks.MOVES,PASSED)
	return report

func set_check(check:int,status:int):
	report[check] = status

func check_passed(check:int):
	if report[check] == PASSED:
		return true
	return false

