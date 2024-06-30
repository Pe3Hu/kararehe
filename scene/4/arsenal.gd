extends MarginContainer


#region var
@onready var weapons = $Weapons

var god = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	god = input_.god
	
	init_basic_setting()


func init_basic_setting() -> void:
	init_weapons()


func init_weapons() -> void:
	for damage in Global.arr.damage:
		var input = {}
		input.damage = damage
		input.size = 3
		input.index = roll_index(input)
		input.letter = roll_letter(input)
		add_weapon(input)


func roll_index(input_: Dictionary) -> int:
	var options = Global.dict.weapon.damage[input_.damage]
	var index = options.pick_random()
	return index


func roll_letter(input_: Dictionary) -> String:
	var options = []
	
	if input_.damage != "blind shell":
		options.append_array(Global.dict.damage.pattern[input_.size][input_.damage])
	else:
		options.append_array(Global.dict.damage.pattern[1][input_.damage])
	
	var letter = options.pick_random()
	return letter


func add_weapon(input_: Dictionary) -> void:
	input_.arsenal = self
	
	var weapon = Global.scene.weapon.instantiate()
	weapons.add_child(weapon)
	weapon.set_attributes(input_)
