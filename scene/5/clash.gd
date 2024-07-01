extends MarginContainer


#region var
@onready var offense = $HBox/Roles/Offense
@onready var defense = $HBox/Roles/Defense
@onready var scope = $HBox/Scope

var planet = null
var gods = {}
var roles = {}
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	planet = input_.planet
	
	init_basic_setting()


func init_basic_setting() -> void:
	var input = {}
	input.clash = self
	scope.set_attributes(input)


func set_role(god_: MarginContainer, role_: String) -> void:
	gods[god_] = role_
	roles[role_] = god_
	var token = get(role_)
	token.replicate(god_.index)
	god_.tactician.set_clash(self)
	
	if gods.keys().size() == 2:
		roles["offense"].opponent = roles["defense"]
		roles["defense"].opponent = roles["offense"]
		
		roles["offense"].core.roll_amplifiers()
		scope.init_pointers()
#end region

