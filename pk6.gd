
var folder = "res://pkmdb/"

func readpk(var path):
	var info = {}
	var array = path.split(" - ",true)
	info["species"] = array[0]
	info["nickname"] = array[1]
	info["id"] = str(array[2])
	var file = File.new()
	var temp_path = path
	file.open(temp_path,File.READ)
	info["gender"] = read_8(file, 0x1D)
	info["move1"] = read_8(file,0x5A)
	info["move2"] = read_8(file,0x5C)
	info["move3"] = read_8(file,0x5E)
	info["move4"] = read_8(file,0x60)
	var bin = BinaryTranslator.int_to_bin(read_32(file,0x74))
	var IVs = ["iv_hp","iv_atk","iv_def","iv_spe","iv_spa","iv_spd"]
	for iv in IVs:
		info[iv] = BinaryTranslator.bin_to_int(bin.right(bin.length() - 5))
		bin.erase(bin.length() - 5,5)
	file.close()
	return info

func read_8(file,pos):
	file.seek(pos)
	var value = file.get_8()
	return value

func read_16(file,pos):
	file.seek(pos)
	var value = file.get_16()
	return value

func read_32(file,pos):
	file.seek(pos)
	var value = file.get_32()
	return value
