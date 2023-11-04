extends Resource

class_name Bank

export var data : Dictionary = {}
export var parties : Dictionary = {}
export var parties_order : Array = []
export var boxes : Dictionary = {}
export var trainer_name : String
export var trainer_picture : Texture
export var first_time_setup : bool = true
export var tutorials = {
	"pokemon_view":false,
	"search":false,
	"party_creator":false
}
export var have_tutorial = false
export var folder_path : String = ""
export var trainers : Array = []
export var version : String = ""
