extends MarginContainer


#region var
@onready var onslaughtBuff = $Generators/Onslaught/Buff
@onready var onslaughtDebuff = $Generators/Onslaught/Debuff
@onready var survivalBuff = $Generators/Survival/Buff
@onready var survivalDebuff = $Generators/Survival/Debuff

var framework = null
var statuses = {}
var generators = []
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	framework = input_.framework
	
	init_basic_setting()


func init_basic_setting() -> void:
	init_generators()


func init_generators() -> void:
	for status in Global.dict.status.title:
		var value = 0
		
		if framework.statuses.has(status):
			for module in framework.statuses[status]:
				value += module.purpose.get_value()
		
		add_generator(status, value)
	
	#update_generators()


func add_generator(status_: String, tempo_: int) -> void:
	var input = {}
	input.bilge = self
	input.status = status_
	input.tempo = tempo_
	
	var description = Global.dict.status.title[status_]
	
	var generator = Global.scene.generator.instantiate()
	var _generators = get(description.subtype+description.type.capitalize())
	_generators.add_child(generator)
	generator.set_attributes(input)
	
	generators.append(generator)
	statuses[status_] = generator
	
	if tempo_ == 0:
		generator.visible = false


func update_generators() -> void:
	pass
#endregion
