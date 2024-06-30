extends MarginContainer


#region var
@onready var hbox = $HBox
@onready var orientation = $HBox/Orientation
@onready var gear = $HBox/Gear
@onready var values = $HBox/Values

var weapon = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	weapon = input_.weapon
	
	init_basic_setting(input_)


func init_basic_setting(input_: Dictionary) -> void:
	custom_minimum_size = Global.vec.size.module
	init_tokens(input_)
	
	for value in input_.values:
		add_value(value)
	
	if input_.values.is_empty():
		hbox.visible = false


func init_tokens(input_: Dictionary) -> void:
	for condition in input_.conditions:
		var token = get(condition)
		var input = {}
		input.proprietor = self
		input.type = condition
		input.subtype = input_.conditions[condition]
		token.set_attributes(input)


func add_value(value_: int) -> void:
	var input = {}
	input.proprietor = self
	input.type = "weapon"
	input.subtype = "condition"
	input.value = value_
	
	var token = Global.scene.token.instantiate()
	values.add_child(token)
	token.set_attributes(input)
