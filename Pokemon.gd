extends Node
var pokemon
func set_data(data):
	pokemon = data.duplicate()
	print(pokemon)

func _on_Search_search(search):
	var results = []
	if search["nickname"] != "":
		for x in pokemon:
			var text = x["nickname"]
			if text.findn(search["nickname"]) >= 0:
				results.push_back(x)
	else:
		results = pokemon
	if search["type1"] != 0:
		for x in results:
			if x["type1"] != search["type1"]:
				var pos = results.find(x)
				results.remove(pos)
	if search["type2"] != 0:
		for x in results:
			if x["type2"] != search["type2"]:
				var pos = results.find(x)
				results.remove(pos)
	if search["gender"] != 1:
		for x in results:
			if x["gender"] != search["gender"]:
				var pos = results.find(x)
				results.remove(pos)
	print(results)
	$"../Search".showResults(results)
