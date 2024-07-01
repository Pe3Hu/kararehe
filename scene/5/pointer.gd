extends MarginContainer


#region var
@onready var slot = $HBox/Slot
@onready var gems = $HBox/Gems
@onready var defect = $HBox/Defect

var scope = null
var weapon = null
var modules = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	for key in input_.keys():
		set(key, input_[key])
	
	init_basic_setting()


func init_basic_setting() -> void:
	init_tokens()
	init_gems()


func init_tokens() -> void:
	var input = {}
	input.proprietor = self
	input.type = "index"
	input.subtype = "weapon"
	input.value = weapon.slot.get_value()
	slot.set_attributes(input)
	
	input.type = "damage"
	input.subtype = weapon.damage
	input.value = 0
	defect.set_attributes(input)


func init_gems() -> void:
	var n = 1
	var remainder = null
	
	if weapon.damage == "blind shell":
		n = weapon.extent
		var module = modules.front()
		remainder = module.gem.get_value()
	
	var vulnerability = Global.dict.vulnerability.damage[weapon.damage]
	var avg = Global.dict.weapon.index[weapon.index].avg
	var amplifier = weapon.arsenal.god.core.get_amplifier_value(weapon.fuel)
	
	for module in modules:
		for _i in n:
			var token = Global.scene.token.instantiate()
			
			gems.add_child(token)
			token.proprietor = self
			token.replicate(module.gem)
			
			var power = weapon.roll_power() * amplifier * vulnerability[token.subtype]
			var limit = token.get_value()
			
			if remainder != null:
				limit = remainder
			
			var value = floor(min(power, limit))
			token.set_value(value)
			defect.change_value(value)
			
			if remainder != null:
				remainder -= value
	
	var ratio = defect.get_value()
	ratio /= weapon.preparation.get_value()
	scope.ratios[self] = ratio
#endregion
