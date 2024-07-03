extends MarginContainer


#region vars
@onready var index = $VBox/HBox/Index
@onready var framework = $VBox/HBox/Framework
@onready var core = $VBox/HBox/Core
@onready var arsenal = $VBox/Arsenal

var pantheon = null
var planet = null
var tactician = null
var opponent = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	pantheon = input_.pantheon
	
	init_basic_setting()


func init_basic_setting() -> void:
	Global.num.index.god += 1
	
	var input = {}
	input.proprietor = self
	input.type = "index"
	input.subtype = "god"
	input.value = Global.num.index.god
	index.set_attributes(input)
	
	input.god = self
	core.set_attributes(input)
	framework.set_attributes(input)
	arsenal.set_attributes(input)
	
	tactician = Classes.Tactician.new(input)
#endregion
