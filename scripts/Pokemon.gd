extends Node
const rates = {
	"erratic":[
		15,   
		37,
		70,    
		115,
		169,
		231,
		305,
		384,
		474,
		569,
		672,
		781,
		897,
		1018,
		1144,
		1274,
		1409,
		1547,
		1689,
		1832,
		1978,
		2127,
		2275,
		2425,
		2575,
		2725,
		2873,
		3022,
		3168,
		3311,
		3453,
		3591,
		3726,
		3856,
		3982,
		4103,
		4219,
		4328,
		4431,
		4526,
		4616,
		4695,
		4769,
		4831,
		4885,
		4930,
		4963,
		4986,
		4999,
		6324,
		6471,
		6615,
		6755,
		6891,
		7023,
		7150,
		7274,
		7391,
		7506,
		7613,
		7715,
		7812,
		7903,
		7988,
		8065,
		8137,
		8201,
		9572,
		9052,
		9870,
		10030,
		9409,
		10307,
		10457,
		9724,
		10710,
		10847,
		9995,
		11073,
		11197,
		10216,
		11393,
		11504,
		10382,
		11667,
		11762,
		10488,
		11889,
		11968,
		10532,
		12056,
		12115,
		10508,
		12163,
		12202,
		10411,
		12206,
		8343,
		8118
	],
	"fast":[
		6,
		15, 
		30,  
		49, 
		72,
		102, 
		135, 
		174, 
		217, 
		264, 
		318, 
		375, 
		438, 
		505, 
		576, 
		654, 
		735, 
		822, 
		913, 
		1008,
		1110,
		1215,
		1326,
		1441,
		1560,
		1686,
		1815,
		1950,
		2089,
		2232,
		2382,
		2535,
		2694,
		2857,
		3024,
		3198,
		3375,
		3558,
		3745,
		3936,
		4134,
		4335,
		4542,
		4753,
		4968,
		5190,
		5415,
		5646,
		5881,
		6120,
		6366,
		6615,
		6870,
		7129,
		7392,
		7662,
		7935,
		8214,
		8497,
		8784,
		9078,
		9375,
		9678,
		9985,
		10296,
		10614,
		10935,
		11262,
		11593,
		11928,
		12270,
		12615,
		12966,
		13321,
		13680,
		14046,
		14415,
		14790,
		15169,
		15552,
		15942,
		16335,
		16734,
		17137,
		17544,
		17958,
		18375,
		18798,
		19225,
		19656,
		20094,
		20535,
		20982,
		21433,
		21888,
		22350,
		22815,
		23286,
		23761
	],
	"medium_fast":[
		8,    
		19,
		37,  
		61,  
		91,  
		127,  
		169,  
		217,
		271,
		331,
		397,
		469,
		547,
		631,
		721,
		817,
		919,
		1027,
		1141,
		1261,
		1387,
		1519,
		1657,
		1801,
		1951,
		2107,
		2269,
		2437,
		2611,
		2791,
		2977,
		3169,
		3367,
		3571,
		3781,
		3997,
		4219,
		4447,
		4681,
		4921,
		5167,
		5419,
		5677,
		5941,
		6211,
		6487,
		6769,
		7057,
		7351,
		7651,
		7957,
		8269,
		8587,
		8911,
		9241,
		9577,
		9919,
		10267,
		10621,
		10981,
		11347,
		11719,
		12097,
		12481,
		12871,
		13267,
		13669,
		14077,
		14491,
		14911,
		15337,
		15769,
		16207,
		16651,
		17101,
		17557,
		18019,
		18487,
		18961,
		19441,
		19927,
		20419,
		20917,
		21421,
		21931,
		22447,
		22969,
		23497,
		24031,
		24571,
		25117,
		25669,
		26227,
		26791,
		27361,
		27937,
		28519,
		29107,
		29701
	],
	"medium_slow":[
		9,	  
		48,
		39,
		39,
		44,
		57,
		78,
		105,
		141,
		182,
		231,
		288,
		351,
		423,
		500,
		585,
		678,
		777,
		885,
		998,
		1119,
		1248,
		1383,
		1527,
		1676,
		1833,
		1998,
		2169,
		2349,
		2534,
		2727,
		2928,
		3135,
		3351,
		3572,
		3801,
		4038,
		4281,
		4533,
		4790,
		5055,
		5328,
		5607,
		5895,
		6188,
		6489,
		6798,
		7113,
		7437,
		7766,
		8103,
		8448,
		8799,
		9159,
		9524,
		9897,
		10278,
		10665,
		11061,
		11462,
		11871,
		12288,
		12711,
		13143,
		13580,
		14025,
		14478,
		14937,
		15405,
		15878,
		16359,
		16848,
		17343,
		17847,
		18356,
		18873,
		19398,
		19929,
		20469,
		21014,
		21567,
		22128,
		22695,
		23271,
		23852,
		24441,
		25038,
		25641,
		26253,
		26870,
		27495,
		28128,
		28767,
		29415,
		30068,
		30729,
		31398,
		32073,
		32757
	],
	"slow":[
		10,
		23,
		47,
		76,
		114,
		158,
		212,
		271,
		339,
		413,
		497,
		586,
		684,
		788,
		902,
		1021,
		1149,
		1283,
		1427,
		1576,
		1734,
		1898,
		2072,
		2251,
		2439,
		2633,
		2837,
		3046,
		3264,
		3488,
		3722,
		3961,
		4209,
		4463,
		4727,
		4996,
		5274,
		5558,
		5852,
		6151,
		6459,
		6773,
		7097,
		7426,
		7764,
		8108,
		8462,
		8821,
		9189,
		9563,
		9947,
		10336,
		10734,
		11138,
		11552,
		11971,
		12399,
		12833,
		13277,
		13726,
		14184,
		14648,
		15122,
		15601,
		16089,
		16583,
		17087,
		17596,
		18114,
		18638,
		19172,
		19711,
		20259,
		20813,
		21377,
		21946,
		22524,
		23108,
		23702,
		24301,
		24909,
		25523,
		26147,
		26776,
		27414,
		28058,
		28712,
		29371,
		30039,
		30713,
		31397,
		32086,
		32784,
		33488,
		34202,
		34921,
		35649,
		36383,
		37127
	],
	"fluctuating":[
		4,
		9,
		19,
		33,
		47,
		66,
		98,
		117,
		147,
		205,
		222,
		263,
		361,
		366,
		500,
		589,
		686,
		794,
		914,
		1042,
		1184,
		1337,
		1503,
		1681,
		1873,
		2080,
		2299,
		2535,
		2786,
		3051,
		3335,
		3634,
		3951,
		4286,
		4639,
		3997,
		5316,
		4536,
		6055,
		5117,
		6856,
		5744,
		7721,
		6417,
		8654,
		7136,
		9658,
		7903,
		10734,
		8722,
		11883,
		9592,
		13110,
		10515,
		14417,
		11492,
		15805,
		12526,
		17278,
		13616,
		18837,
		14766,
		20485,
		15976,
		22224,
		17247,
		24059,
		18581,
		25989,
		19980,
		28017,
		21446,
		30146,
		22978,
		32379,
		24580,
		34717,
		26252,
		37165,
		27995,
		39722,
		29812,
		42392,
		31704,
		45179,
		33670,
		48083,
		35715,
		51108,
		37839,
		54254,
		40043,
		57526,
		42330,
		60925,
		44699,
		64455,
		47153,
		68116
	]
}
const types_def = {
		1:{"fighting":2,"ghost":0},
		2:{"fire":0.5,"water":2,"grass":0.5,"ice":0.5,"ground":2,"bug":0.5,"rock":2,"steel":0.5,"fairy":0.5},
		3:{"fire":0.5,"water":0.5,"electric":2,"grass":2,"ice":0.5,"steel":0.5},
		4:{"fire":2,"water":0.5,"electric":0.5,"grass":0.5,"ice":2,"poison":2,"ground":0.5,"flying":2,"bug":2},
		5:{"electric":0.5,"ground":2,"flying":0.5,"steel":0.5},
		6:{"fire":2,"ice":0.5,"fighting":2,"rock":2,"steel":2},
		7:{"flying":2,"psychic":2,"bug":0.5,"rock":0.5,"dark":0.5,"fairy":2},
		8:{"grass":0.5,"fighting":0.5,"poison":0.5,"ground":2,"psychic":2,"bug":0.5,"fairy":0.5},
		9:{"water":2,"electric":0,"grass":2,"ice":2,"poison":0.5,"rock":0.5},
		10:{"electric":2,"grass":0.5,"ice":2,"fighting":0.5,"ground":0,"bug":0.5,"rock":2},
		11:{"fighting":0.5,"psychic":0.5,"bug":2,"ghost":2,"dark":2},
		12:{"fire":2,"grass":0.5,"fighting":0.5,"ground":0.5,"flying":2,"rock":2},
		13:{"normal":0.5,"fire":0.5,"water":2,"grass":2,"fighting":2,"poison":0.5,"ground":2,"flying":0.5,"steel":2},
		14:{"normal":0,"fighting":0,"poison":0.5,"bug":0.5,"ghost":2,"dark":2},
		15:{"fighting":2,"psychic":0,"bug":2,"ghost":0.5,"dark":0.5,"fairy":2},
		16:{"fire":0.5,"water":0.5,"electric":0.5,"grass":0.5,"ice":2,"dragon":2,"fairy":2},
		17:{"normal":0.5,"fire":2,"grass":0.5,"ice":0.5,"fighting":2,"poison":0,"ground":2,"flying":0.5,"psychic":0.5,"bug":0.5,"rock":0.5,"dragon":0.5,"steel":0.5,"fairy":0.5},
		18:{"fighting":0.5,"poison":2,"bug":0.5,"dragon":0,"dark":0.5,"steel":2}
}
const types_atk = {
	"normal":[13,14,17],
	"fire":[2,3,4,6,12,16],
	"water":[2,3,4,9,16],
	"grass":[2,3,4]
}
enum {
	# Pok??mon Sapphire (GBA)
	S = 1,

	# Pok??mon Ruby (GBA)
	R = 2,

	# Pok??mon Emerald (GBA)
	E = 3,

	# Pok??mon FireRed (GBA)
	FR = 4,

	# Pok??mon LeafGreen (GBA)
	LG = 5,

	# Pok??mon Diamond (NDS)
	D = 10,
	
	# Pok??mon Pearl (NDS)
	P = 11,

	# Pok??mon Platinum (NDS)
	Pt = 12,

	# Pok??mon HeartGold (NDS)
	HG = 7,

	# Pok??mon SoulSilver (NDS)
	SS = 8,

	# Pok??mon White (NDS)
	W = 20,

	# Pok??mon Black (NDS)
	B = 21,

	# Pok??mon White 2 (NDS)
	W2 = 22,

	# Pok??mon Black 2 (NDS)
	B2 = 23,

	# Pok??mon X (3DS)
	X = 24,

	# Pok??mon Y (3DS)
	Y = 25,
	
	# Pok??mon Alpha Sapphire (3DS)
	AS = 26,
	
	# Pok??mon Omega Ruby (3DS)
	OR = 27,
  
	# Pok??mon Sun (3DS)
	Sn = 30,

	# Pok??mon Moon (3DS)
	Mn = 31,

	# Pok??mon Ultra Sun (3DS)
	US = 32,

	# Pok??mon Ultra Moon (3DS)
	UM = 33,
}
var pokemon = {}
func set_data(data):
	pokemon = data.duplicate()

func search(search):
	var results = []
	if search["nickname"] != "":
		for x in pokemon.keys():
			var text = pokemon[x]["nickname"]
			if text.findn(search["nickname"]) >= 0:
				results.push_back(x)
	else:
		results = pokemon.keys()
	if search["type1"] != 0:
		var ids = results.duplicate()
		for x in ids:
			print(search)
			if pokemon[x]["type1"] != search["type1"]:
				print("Erased "+x+" because of "+str(pokemon[x]["type1"]))
				results.erase(x)
	if search["type2"] != 0:
		var ids = results.duplicate()
		for x in ids:
			if pokemon[x]["type2"] != search["type2"]:
				print("Erased "+x+" because of "+str(pokemon[x]["type2"]))
				results.erase(x)
	if search["gender"] != 3:
		var ids = results.duplicate()
		for x in ids:
			if pokemon[x]["gender"] != search["gender"]:
				print("Erased "+x+" because of "+str(pokemon[x]["gender"]))
				results.erase(x)
	print(search["ot"])
	print(search["ot"] != null)
	if search["ot"] != null:
		var ids = results.duplicate()
		for x in ids:
			if pokemon[x]["ot"].values() != search["ot"].values():
				print("Erased "+x+" because of "+str(pokemon[x]["ot"]))
				results.erase(x)
	print(results)
	return results

func level(var Exp, var rate):
	var level = 0
	match rate:
		"slow":
			for exp_required in rates.slow:
				Exp -= exp_required
				level += 1
				if Exp <=0:
					break
				else:
					continue
		"medium":
			for exp_required in rates.medium_fast:
				Exp -= exp_required
				level += 1
				if Exp <=0:
					break
				else:
					continue
		"fast":
			for exp_required in rates.fast:
				Exp -= exp_required
				level += 1
				if Exp <=0:
					break
				else:
					continue
		"medium-slow":
			for exp_required in rates.medium_slow:
				Exp -= exp_required
				level += 1
				if Exp <=0:
					break
				else:
					continue
		"slow then very fast":
			for exp_required in rates.erratic:
				Exp -= exp_required
				level += 1
				if Exp <=0:
					break
				else:
					continue
		"fast then very slow":
			for exp_required in rates.fluctuating:
				Exp -= exp_required
				level += 1
				if Exp < 0:
					break
				else:
					continue
	return level

func EggGroups(var egg_groups):
	var array = []
	for group in egg_groups:
		array.append(group.name)
	return array

func gameVersion(id):
	var version = ""
	match id:
		S:
			version = "Pok??mon Sapphire (GBA)"
		R:
			version = "Pok??mon Ruby (GBA)"
		E:
			version = "Pok??mon Emerald (GBA)"
		FR:
			version = "Pok??mon FireRed (GBA)"
		LG:
			version = "Pok??mon LeafGreen (GBA)"
		D:
			version = "Pok??mon Diamond (NDS)"
		P:
			version = "Pok??mon Pearl (NDS)"
		Pt:
			version = "Pok??mon Platinum (NDS)"
		HG:
			version = "Pok??mon HeartGold (NDS)"
		SS:
			version = "Pok??mon SoulSilver (NDS)"
		W:
			version = "Pok??mon White (NDS)"
		B:
			version = "Pok??mon Black (NDS)"
		W2:
			version = "Pok??mon White 2 (NDS)"
		B2:
			version = "Pok??mon Black 2 (NDS)"
		X:
			version = "Pok??mon X (3DS)"
		Y:
			version = "Pok??mon Y (3DS)"
		AS:
			version = "Pok??mon Alpha Sapphire (3DS)"
		OR:
			version = "Pok??mon Omega Ruby (3DS)"
		Sn:
			version = "Pok??mon Sun (3DS)"
		Mn:
			version = "Pok??mon Moon (3DS)"
		US:
			version = "Pok??mon Ultra Sun (3DS)"
		UM:
			version = "Pok??mon Ultra Moon (3DS)"
	return version

func getLocation(location_id,game):
	var file = File.new()
	match game:
		20,21,22,23:
			file.open("res://locations/gen5/location_0000_en.txt",File.READ)
		24,25,26,27:
			file.open("res://locations/gen6/location_0000_en.txt",File.READ)
		30,31,32,33:
			file.open("res://locations/gen7/location_0000_en.txt",File.READ)
	var pos = location_id
	while pos >= 1:
		file.get_line()
		pos -= 1
	var location = file.get_line()
	print(location)
	file.close()
	return location
