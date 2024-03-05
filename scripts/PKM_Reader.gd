extends Node

class_name PKM_FILE
var unused_hex_offsets = []

func set_file_hex_locations(size):
	var offset = 0x00
	while offset < size:
		unused_hex_offsets.append(offset)
		offset += 0x01

func get_unused_hex_locations():
	return unused_hex_offsets

func get_unused_data_with_hex_keys(file:File):
	var data = {}
	for offset in unused_hex_offsets:
		var byte = read_8(file,offset)
		if byte != 0:
			data[offset] = byte
	return data

func read_8(file,pos):
	unused_hex_offsets.erase(pos)
	file.seek(pos)
	var value = file.get_8()
	return value

func read_16(file,pos):
	for n in 2:
		unused_hex_offsets.erase(pos+n)
	file.seek(pos)
	var value = file.get_16()
	return value

func read_32(file,pos):
	for n in 4:
		unused_hex_offsets.erase(pos+n)
	file.seek(pos)
	var value = file.get_32()
	return value

func write_8(file:File,pos,data):
	file.seek(pos)
	file.store_8(data)

func write_16(file:File,pos,data):
	file.seek(pos)
	file.store_16(data)

func write_32(file:File,pos,data):
	file.seek(pos)
	file.store_32(data)

