extends MarginContainer


#region var
@onready var bg = $BG
@onready var gem = $Gem
@onready var purpose = $Purpose

var proprietor = null
var grid = null
var orientation = null
var neighbors = {}
var directions = {}
var gear = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	proprietor = input_.proprietor
	grid = input_.grid
	orientation = input_.orientation
	
	init_basic_setting()


func init_basic_setting() -> void:
	proprietor.grids[grid] = self
	
	init_tokens()


func set_gear(gear_: String) -> void:
	gear = gear_
	
	init_bg()
	set_bg_color(Global.color.module[gear_])


func init_bg() -> void:
	var style = StyleBoxFlat.new()
	style.bg_color = Color.SLATE_GRAY
	bg.set("theme_override_styles/panel", style)


func set_bg_color(color_: Color) -> void:
	var style = bg.get("theme_override_styles/panel")
	style.bg_color = color_


func init_tokens() -> void:
	var keys = ["gem", "purpose"]
	
	for key in keys:
		var token = get(key)
		
		var input = {}
		input.proprietor = self
		input.type = key
		input.subtype = "blank"
		input.value = grid.y * 5  + grid.x
		token.set_attributes(input)
		token.custom_minimum_size = Global.vec.size.module


func set_gem(subtype_: String, durability_: int) -> void:
	gem.set_subtype(subtype_)
	gem.set_value(durability_)


func roll_purpose() -> void:
	var exceptions = []
	
	for neighbor in neighbors:
		if neighbor.purpose.subtype != "blank":
			exceptions.append(neighbor.purpose.subtype)
	
	var weights = {}
	
	for resource in Global.dict.resource.title[gear]:
		var weight = Global.dict.resource.title[gear][resource]
		
		for _purpose in Global.dict.purpose.resource[resource]:
			if !exceptions.has(_purpose):
				weights[_purpose] = weight
	
	var subtype = Global.get_random_key(weights)
	purpose.set_subtype(subtype)
	
	Global.rng.randomize()
	var value = Global.rng.randi_range(Global.num.purpose.min, Global.num.purpose.max)
	purpose.set_value(value)
	
	var status = Global.dict.purpose.title[subtype].status
	
	if !proprietor.statuses.has(status):
		proprietor.statuses[status] = []
	
	proprietor.statuses[status].append(self)
#endregion


func get_damage() -> void:
	gear.change_value(-1)


func check_pattern(pattern_: Array) -> bool:
	var pattern = []
	pattern.append_array(pattern_)
	pattern.pop_front()
	
	for direction in pattern:
		var _grid = grid + direction
		
		if !proprietor.grids.has(_grid):
			return false
	
	return true


func check_condition(pattern_: Array, condition_: Dictionary) -> bool:
	var modules = []
	
	for direction in pattern_:
		var _grid = grid + direction
		var module = proprietor.grids[_grid]
		var flags = []
		
		for type in condition_.types:
			var subtype = condition_.types[type]
			var flag = module.get(type) == subtype
			flags.append(flag)
		
		if !flags.has(false):
			modules.append(module)
	
	return condition_.values.has(modules.size())
