extends Node

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
	return binary

func bin_to_int(binary):
	var number = 0
	while binary.length() > 0:
		var byte = int(binary[0])
		if byte == 1:
			number += pow(2,binary.length() - 1)
		binary.erase(0,1)
	return int(number)

func bitshiftR(binary,shift):
	binary.erase(binary.length() - shift, shift)
	return binary

func bitshiftL(binary,shift):
	binary.erase()
