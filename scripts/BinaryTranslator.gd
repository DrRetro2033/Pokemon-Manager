extends Node
#proud of this :)
#This is a binary translator that is meant to do binary calculations
func int_to_bin(number):
	var binary = ""
	var num_div = float(number)
	while num_div != 0:
		num_div /= 2
		if floor(num_div) != ceil(num_div):
			binary = "1"+binary
		elif floor(num_div) == ceil(num_div):
			binary = "0"+binary
		num_div = floor(num_div)
	binary = valid_size(binary)
	return binary

func bin_to_int(binary):
	var number = 0
	while binary.length() > 0:
		var byte = int(binary[0])
		if byte == 1:
			number += pow(2,binary.length() - 1)
		binary.erase(0,1)
	return int(number)

#VERY MISLEADING NAME, CHANGE IN FUTURE
func int_to_hex(to_convert:int): #converts an integer to a PoolByteArray.
	var pool : PoolByteArray = []
	var bin = int_to_bin(to_convert)
	var x = ceil(float(bin.length()) / 8.0) #calculates the amount of bytes that is needed. 
	while bin.length() > 0:
		#get 8 bits, convert it to an integer and add to pool, remove them from the rest, and repeat.
		pool.append(bin_to_int(bin.left(8))) 
		bin = bitshiftL(bin,8)
	print(pool)
	return pool

func invert_binary(binary:String):
	var inv_bin : String = ""
	var x = binary.length()-1
	while x >= 0:
		inv_bin = binary[x] + inv_bin
		x -= 1
	return inv_bin

func bitshiftR(binary,shift):
	binary.erase(binary.length() - shift, shift)
	return binary

func bitshiftL(binary,shift):
	binary.erase(0,shift)
	return binary

func valid_size(binary:String): #checks and updates a binary string to make sure that it's size is a multiple of 8.
	var multi_mod = ceil(float(binary.length()) / 8.0)
	print("Multi Mod: "+str(multi_mod)+" Binary: "+binary)
	while binary.length() < 8*multi_mod:
		binary = '0'+binary
	return binary
