extends MarginContainer


#region var
@onready var bg = $BG
@onready var gear = $Gear

var proprietor = null
var grid = null
var orientation = null
var neighbors = {}
var directions = {}
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	proprietor = input_.proprietor
	grid = input_.grid
	orientation = input_.orientation
	
	init_basic_setting()


func init_basic_setting() -> void:
	proprietor.grids[grid] = self
	#if orientation == "core":
	#	type.visible = false


func set_type(type_: String) -> void:
	var input = {}
	input.proprietor = self
	input.type = "gear"
	input.subtype = type_
	input.value = grid.y * 5  + grid.x
	gear.set_attributes(input)
	gear.custom_minimum_size = Global.vec.size.module
	
	gear.init_bg()
	gear.set_bg_color(Global.color.module[type_])
	
	#for specialization in Global.arr.specialization:
		#var weight = Global.dict.specialization.title[type_][specialization]
		#proprietor.core.change_specialization_value(specialization, weight)


func get_available_neighbors() -> Array:
	var available = []
	
	for neighbor in neighbors:
		if !neighbor.fade and neighbor.pillar == null:
			available.append(neighbor)
	
	return available


func get_count_available_neighbors() -> int:
	var available = 0
	
	for neighbor in neighbors:
		if !neighbor.fade and neighbor.pillar == null:
			available += 1
	
	return available 


func clean() -> void:
	for neighbor in neighbors:
		neighbor.neighbors.erase(self)
	
	for direction in directions:
		var neighbor = directions[direction]
		neighbor.directions.erase(-direction)
	
	proprietor.grids.erase(grid)
	
	get_parent().remove_child(self)
	queue_free()
#endregion


func get_damage() -> void:
	gear.change_value(-1)
