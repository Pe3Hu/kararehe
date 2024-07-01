extends MarginContainer


#region var
@onready var gods = $HBox/Gods
@onready var clash = $HBox/Clash

var universe = null
var rank = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	universe = input_.universe
	
	init_basic_setting()


func init_basic_setting() -> void:
	rank = 1
	
	var input = {}
	input.planet = self
	clash.set_attributes(input)


func add_god(god_: MarginContainer) -> void:
	god_.pantheon.gods.remove_child(god_)
	gods.add_child(god_)
	god_.planet = self
#endregion


func start_race() -> void:
	var _gods = gods.get_children()
	clash.set_role(_gods[0], "offense")
	clash.set_role(_gods[1], "defense")
