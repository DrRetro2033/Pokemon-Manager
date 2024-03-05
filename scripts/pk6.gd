extends PKM_FILE

func readpk(var path):
	print(path)
	var info = {}
	var file = File.new()
	file.open(path,File.READ)
	set_file_hex_locations(file.get_len())
	info["id"] = path.get_file()
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
	print("Ability: "+str(read_8(file,0x14)))
	print("Ability Number: "+str(read_8(file,0x15)))
	info["ability_number"] = read_8(file,0x15)
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
	info["unused-data"] = get_unused_data_with_hex_keys(file)
	file.close()
	return info

func writepk(path,info):
	print(path)
	var file = File.new()
	file.open(path,File.WRITE)
	write_16(file,0x08,info["species"])
	write_16(file,0x5A,info["move1"]["id"])
	write_16(file,0x5C,info["move2"]["id"])
	write_16(file,0x5E,info["move3"]["id"])
	write_16(file,0x60,info["move4"]["id"])
	write_32(file,0x10,info["exp"])
	var bin = ""
	var IVs = ["iv_hp","iv_atk","iv_def","iv_spe","iv_spa","iv_spd"]
	IVs.invert()
	for iv in IVs:
		bin += BinaryTranslator.int_to_bin_with_no_resize(info[iv])
	if info["nickname"] != info["species-name"]:
		bin.insert(0,'1')
	else:
		bin.insert(0,'0')
	bin = BinaryTranslator.valid_size(bin)
	write_32(file,0x74,BinaryTranslator.bin_to_int(bin))
	write_8(file,0x1E,info["ev_hp"])
	write_8(file,0x1F,info["ev_atk"])
	write_8(file,0x20,info["ev_def"])
	write_8(file,0x21,info["ev_spe"])
	write_8(file,0x22,info["ev_spa"])
	write_8(file,0x23,info["ev_spd"])
	print(info["ability"]["ability"]["url"].get_slice('/',4))
	write_8(file,0x14,int(info["ability"]["ability"]["url"].get_slice('/',4)))
	write_8(file,0x15,info["ability_number"])
	var nickname = ""
	var byte : PoolByteArray = [0]
	if info["nickname"] != info["species-name"]:
		for charater in info["nickname"]:
			nickname += charater+' '
		nickname += byte.get_string_from_utf8()
		file.seek(0x40)
		file.store_string(nickname)
	nickname = ""
	for charater in info["ot"]["nickname"]:
		nickname += charater+' '
	nickname += byte.get_string_from_utf8()
	file.seek(0xB0)
	file.store_string(nickname)
	write_8(file,0xDF,info["ot"]["game"])
	write_16(file,0x0C,info["ot"]["id"])
	bin = ""
	bin += BinaryTranslator.int_to_bin_with_no_resize(info["met_level"])
	bin.insert(0,str(info["ot"]["gender"]))
	bin = BinaryTranslator.valid_size(bin)
	write_8(file,0xDD,BinaryTranslator.bin_to_int(bin))
	write_16(file,0xDA,info["met_location"])
	bin = ""
	bin += BinaryTranslator.int_to_bin_with_no_resize(info["form"])
	bin += BinaryTranslator.int_to_bin_with_no_resize(info["gender"])
	bin = BinaryTranslator.valid_size(bin)
	write_8(file,0x1D,BinaryTranslator.bin_to_int(bin))
	file.close()
