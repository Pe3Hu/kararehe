extends MarginContainer


@onready var cradle = $HBox/Cradle
@onready var universe = $HBox/Universe


func _ready() -> void:
	var input = {}
	input.sketch = self
	cradle.set_attributes(input)
	universe.set_attributes(input)
	
	var planet = universe.planets.get_child(0)
	
	for pantheon in cradle.pantheons.get_children():
		var god = pantheon.gods.get_child(0)
		planet.add_god(god)
	
	planet.start_race()
