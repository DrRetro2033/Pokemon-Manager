extends PKM_FILE

func readpk(var path):
	print(path)
	var info = {}
	var file = File.new()
	file.open(path,File.READ)
	info["id"] = path.get_file()
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
	info["ev_hp"] = read_8(file,0x18)
	info["ev_atk"] = read_8(file,0x19)
	info["ev_def"] = read_8(file,0x1A)
	info["ev_spe"] = read_8(file,0x1B)
	info["ev_spa"] = read_8(file,0x1C)
	info["ev_spd"] = read_8(file,0x1D)
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
	nickname = ""
	file.seek(0x68)
	while true:
		if file.get_8() == 0:
			break
		file.seek(file.get_position() - 1)
		nickname = nickname+file.get_line()
		print(nickname)
	info["ot"] = {}
	info["ot"]["nickname"] = nickname
	info["ot"]["game"] = read_8(file,0x5F)
	info["ot"]["id"] = read_16(file,0x0C)
	bin = BinaryTranslator.int_to_bin(read_8(file,0x84))
	info["met_level"] = BinaryTranslator.bin_to_int(bin.right(bin.length() - 7))
	bin = BinaryTranslator.bitshiftR(bin,7)
	info["ot"]["gender"] = int(bin)
	info["met_location"] = read_16(file,0x80)
	Trainer.addTrainer(info["ot"])
	var form_gender = BinaryTranslator.int_to_bin(read_8(file, 0x40))
	form_gender = BinaryTranslator.bitshiftR(form_gender,1)
	info["gender"] = BinaryTranslator.bin_to_int(form_gender.right(form_gender.length() - 2))
	form_gender = BinaryTranslator.bitshiftR(form_gender,2)
	info["form"] = BinaryTranslator.bin_to_int(form_gender.right(form_gender.length() - 2))
	file.close()
	return info
