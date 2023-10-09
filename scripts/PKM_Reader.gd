extends Node

class_name PKM_FILE

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

func write_8(file:File,pos,data):
	file.seek(pos)
	file.store_8(data)

func write_16(file:File,pos,data):
	file.seek(pos)
	file.store_16(data)

func write_32(file:File,pos,data):
	file.seek(pos)
	file.store_32(data)

