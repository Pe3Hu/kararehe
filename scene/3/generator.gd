extends MarginContainer


#region var
@onready var status = $VBox/HBox/Status
@onready var tempo = $VBox/HBox/Tempo
@onready var indicator = $VBox/Indicator

var bilge = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	bilge = input_.bilge
	
	init_basic_setting(input_)


func init_basic_setting(input_: Dictionary) -> void:
	init_tokens(input_)
	
	var input = {}
	input.generator = self
	input.type = "generation"
	input.max = 100
	indicator.set_attributes(input)
	


func init_tokens(input_: Dictionary) -> void:
	var keys = ["status", "tempo"]
	
	for key in keys:
		var token = get(key)
		
		var input = {}
		input.proprietor = self
		input.type = key
		
		if key == "tempo":
			input.value = input_[key]
			input.subtype = "basic"
		else:
			input.subtype = input_[key]
		
		token.set_attributes(input)
		token.custom_minimum_size = Global.vec.size.generator
#endregion
