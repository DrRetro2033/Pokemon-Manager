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
	info["move1"] = read_16(file,0x5A)
	info["move2"] = read_16(file,0x5C)
	info["move3"] = read_16(file,0x5E)
	info["move4"] = read_16(file,0x60)
	info["exp"] = read_32(file,0x10)
	var bin = BinaryTranslator.int_to_bin(read_32(file,0x74))
	var IVs = ["iv_hp","iv_atk","iv_def","iv_spe","iv_spa","iv_spd"]
	for iv in IVs:
		info[iv] = BinaryTranslator.bin_to_int(bin.right(bin.length() - 5))
		bin = BinaryTranslator.bitshiftR(bin, 5)
	info["ev_hp"] = read_8(file,0x1E)
	info["ev_atk"] = read_8(file,0x1F)
	info["ev_def"] = read_8(file,0x20)
	info["ev_spe"] = read_8(file,0x21)
	info["ev_spa"] = read_8(file,0x22)
	info["ev_spd"] = read_8(file,0x23)
	bin = BinaryTranslator.bitshiftR(bin, 1)
	print(bin)
	var nickname = ""
	if int(bin) == 1:
		file.seek(0x40)
		while true:
			if file.get_8() == 0:
				break
			file.seek(file.get_position() - 1)
			nickname = nickname+file.get_line()
			print(nickname)
	info["nickname"] = nickname
	nickname = ""
	file.seek(0xB0)
	while true:
		if file.get_8() == 0:
			break
		file.seek(file.get_position() - 1)
		nickname = nickname+file.get_line()
		print(nickname)
	info["ot"] = {}
	info["ot"]["nickname"] = nickname
	info["ot"]["game"] = read_8(file,0xDF)
	info["ot"]["id"] = read_16(file,0x0C)
	bin = BinaryTranslator.int_to_bin(read_8(file,0xDD))
	info["met_level"] = BinaryTranslator.bin_to_int(bin.right(bin.length() - 7))
	bin = BinaryTranslator.bitshiftR(bin,7)
	info["ot"]["gender"] = int(bin)
	info["met_location"] = read_16(file,0xDA)
	Trainer.addTrainer(info["ot"])
	var form_gender = BinaryTranslator.int_to_bin(read_8(file, 0x1D))
	form_gender = BinaryTranslator.bitshiftR(form_gender,1)
	info["gender"] = BinaryTranslator.bin_to_int(form_gender.right(form_gender.length() - 2))
	form_gender = BinaryTranslator.bitshiftR(form_gender,2)
	info["form"] = BinaryTranslator.bin_to_int(form_gender.right(form_gender.length() - 2))
	file.close()
	return info
