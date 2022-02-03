
var folder = "res://pkmdb/"

func readpk(var path):
	var array = path.split(" - ",true)
	var species = array[0]
	var nickname = array[1]
	var id = str(array[2])
	var file = File.new()
	var temp_path = folder+path
	file.open(temp_path,File.READ)
	var gender = read_8(file, 0x1D)
	var move1 = read_8(file,0x5A)
	var move2 = read_8(file,0x5C)
	var move3 = read_8(file,0x5E)
	var move4 = read_8(file,0x60)
	file.close()
	var info = [species,nickname,gender,id,move1,move2,move3,move4]
	return info

func read_8(file,pos):
	file.seek(pos)
	var value = file.get_8()
	return value
