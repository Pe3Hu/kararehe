extends MarginContainer


#region var
@onready var generators = $Generators

var framework = null
var statuses = {}
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
	
	var generator = Global.scene.generator.instantiate()
	generators.add_child(generator)
	generator.set_attributes(input)
	statuses[status_] = generator
	
	if tempo_ == 0:
		generator.visible = false


func update_generators() -> void:
	pass
#endregion
