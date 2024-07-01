extends MarginContainer


#region var
@onready var pointers = $Pointers

var clash = null
var arsenal = null
var framework = null
var ratios = {}
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	clash = input_.clash
	
	init_basic_setting()


func init_basic_setting() -> void:
	pass


func init_pointers() -> void:
	arsenal = clash.roles["offense"].arsenal
	framework = clash.roles["defense"].framework
	
	#var weapon = arsenal.weapons.get_child(3)
	for weapon in arsenal.weapons.get_children():
		var grids = get_all_grids(weapon)
		
		if !grids.is_empty():
			var datas = []
			var vulnerability = Global.dict.vulnerability.damage[weapon.damage]
			
			for grid in grids:
				for pattern in grids[grid]:
					var data = {}
					data.grid = grid
					data.pattern = pattern
					data.weight = 0
					
					for direction in pattern:
						var _grid = grid + direction
						var module = framework.grids[_grid]
						var multiplier = vulnerability[module.gem.subtype]
						data.weight += multiplier
					
					datas.append(data)
			
			datas.sort_custom(func(a, b): return a.weight > b.weight)
			
			var bests = []
			bests.append(datas.pop_front())
			var flag = !datas.is_empty()
			
			while flag:
				if bests.front().weight == datas.front().weight:
					bests.append(datas.pop_front())
					flag = !datas.is_empty()
				else:
					flag = false
			
			var best = bests.pick_random()
			var grid = best.grid#grids.keys().pick_random()
			var pattern = best.pattern#grids[grid].pick_random()
			var modules = []
			
			for direction in pattern:
				var _grid = grid + direction
				var module = framework.grids[_grid]
				modules.append(module)
				#module.gem.set_value(0)
			
			add_pointer(weapon, modules)
			#print(bests)
			#print(datas)
		else:
			pass
	
	sort_pointers()


func get_all_grids(weapon_: MarginContainer) -> Dictionary:
	var grids = {}
	var condition = weapon_.condition.description
	
	if condition.values.is_empty():
		condition = null
	
	for module in framework.modules.get_children():
		for pattern in Global.dict.pattern.turns[weapon_.letter]:
			if module.check_pattern(pattern):
				var flag = true
				
				
				if condition != null:
					flag = module.check_condition(pattern, condition)
				
				if flag:
					if !grids.has(module.grid):
						grids[module.grid] = []
					
					grids[module.grid].append(pattern)
	
	
	return grids


func add_pointer(weapon_: MarginContainer, modules_: Array) -> void:
	var input = {}
	input.scope = self
	input.weapon = weapon_
	input.modules = modules_
	
	var pointer = Global.scene.pointer.instantiate()
	pointers.add_child(pointer)
	pointer.set_attributes(input)


func sort_pointers() -> void:
	var datas = []
	
	while pointers.get_child_count() > 0:
		var data = {}
		data.pointer = pointers.get_child(0)
		data.ratio = ratios[data.pointer]
		pointers.remove_child(data.pointer)
		datas.append(data)
	
	datas.sort_custom(func(a, b): return a.ratio > b.ratio)
	
	for data in datas:
		pointers.add_child(data.pointer)
#endregion
