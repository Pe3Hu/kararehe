extends MarginContainer


#region var
@onready var pattern = $VBox/HBox/Pattern
@onready var preparation = $VBox/HBox/Preparation
@onready var power = $VBox/Power
@onready var condition = $VBox/Condition

var arsenal = null
var index = null
var letter = null
var damage = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	for key in input_.keys():
		set(key, input_[key])
	
	init_basic_setting()


func init_basic_setting() -> void:
	init_tokens()
	init_power()
	init_power()
	init_condition()


func init_tokens() -> void:
	var description = Global.dict.weapon.index[index]
	
	var input = {}
	input.proprietor = self
	input.type = description.damage
	input.subtype = letter
	pattern.set_attributes(input)
	pattern.custom_minimum_size = Global.vec.size.pattern
	
	input.type = "weapon"
	input.subtype = "preparation"
	input.value = description.preparation
	preparation.set_attributes(input)



func init_power() -> void:
	var description = Global.dict.weapon.index[index]
	
	var input = {}
	input.weapon = self
	input.tokens = {}
	input.tokens["damage"] = description.damage
	input.tokens["minimum"] = description.powers.min
	input.tokens["maximum"] = description.powers.max
	power.set_attributes(input)


func init_condition() -> void:
	var input = {}
	input.weapon = self
	var _condition = Global.arr.condition.pick_random()
	input.conditions = {}
	input.conditions[_condition] = roll_condition(_condition)
	input.values = roll_values(input.conditions[_condition])
	condition.set_attributes(input)


func roll_condition(condition_: String) -> String:
	var options = Global.arr[condition_]
	var option = options.pick_random()
	return option


func roll_values(condition_: String) -> Array:
	var values = []
	
	if letter == "a":
		values = [1]
		return values
	
	if condition_ == "nexus":
		var options = [0, 1]
		var value = options.pick_random()
		values.append(value)
	else:
		var _sign = Global.arr.sign.pick_random()
		var restriction = Global.arr.restriction.pick_random()
		
		for value in Global.arr.restriction:
			match _sign:
				"less":
					if restriction > value:
						values.append(value)
				"equal":
					if restriction == value:
						values.append(value)
				"more":
					if restriction < value:
						values.append(value)
	
	if condition_ == "corner":
		values.erase(2)
	
	if values.size() == 1:
		if values.front() == 0:
			if condition_ == "axis":
				var letters = ["l", "i", "j", "z", "t"]
				
				if letters.has(letter):
					values.erase(0)
	
	return values
#endregion
