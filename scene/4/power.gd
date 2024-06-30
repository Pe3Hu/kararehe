extends MarginContainer


#region var
@onready var damage = $HBox/Damage
@onready var minimum = $HBox/Minimum
@onready var maximum = $HBox/Maximum

var weapon = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	weapon = input_.weapon
	
	init_basic_setting(input_)


func init_basic_setting(input_: Dictionary) -> void:
	init_tokens(input_)


func init_tokens(input_: Dictionary) -> void:
	for key in input_.tokens:
		var token = get(key)
		var input = {}
		input.proprietor = self
		input.type = "weapon"
		input.subtype = key
		
		if key == "damage":
			input.type = key
			input.subtype = weapon.damage
		else:
			input.value = input_.tokens[key]
		
		token.set_attributes(input)
