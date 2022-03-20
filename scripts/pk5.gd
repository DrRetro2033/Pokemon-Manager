extends PKM_FILE

var folder = "res://pkmdb/"

func readpk(var path):
	print(path)
	var info = {}
	info["id"] = path
	var file = File.new()
	var temp_path
	if OS.get_executable_path().get_base_dir() != "C:/Program Files (x86)/Steam/steamapps/common/Godot Engine":
		temp_path = OS.get_executable_path().get_base_dir()+"/pkmdb/"+path
	else:
		temp_path = folder+path
	print(temp_path)
	file.open(temp_path,File.READ)
	info["species"] = read_16(file,0x08)
	info["move1"] = read_16(file,0x28)
	info["move2"] = read_16(file,0x2A)
	info["move3"] = read_16(file,0x2C)
	info["move4"] = read_16(file,0x2E)
	info["exp"] = read_32(file,0x10)
	var bin = BinaryTranslator.int_to_bin(read_32(file,0x38))
	var IVs = ["iv_hp","iv_atk","iv_def","iv_spe","iv_spa","iv_spd"]
	for iv in IVs:
		info[iv] = BinaryTranslator.bin_to_int(bin.right(bin.length() - 5))
		bin = BinaryTranslator.bitshiftR(bin, 5)
	bin = BinaryTranslator.bitshiftR(bin, 1)
	print(bin)
	var nickname = ""
	if int(bin) == 1:
		file.seek(0x48)
		while true:
			if file.get_8() == 0:
				break
			file.seek(file.get_position() - 1)
			nickname = nickname+file.get_line()
			print(nickname)
	info["nickname"] = nickname
	var form_gender = BinaryTranslator.int_to_bin(read_8(file, 0x40))
	form_gender = BinaryTranslator.bitshiftR(form_gender,1)
	info["gender"] = BinaryTranslator.bin_to_int(form_gender.right(form_gender.length() - 2))
	form_gender = BinaryTranslator.bitshiftR(form_gender,2)
	info["form"] = BinaryTranslator.bin_to_int(form_gender.right(form_gender.length() - 2))
	file.close()
	return info
