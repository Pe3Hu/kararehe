extends Node


class Tactician:
	var god = null
	var clash = null
	var role = null
	var modules = []
	var doublet = null
	var directive = null
	var axis = null


	func _init(input_: Dictionary) -> void:
		god = input_.god
	
		init_basic_setting()


	func init_basic_setting() -> void:
		pass
	
	
	func set_clash(clash_: MarginContainer) -> void:
		clash = clash_
		role = clash.gods[god]
	
	
	func select_directive() -> void:
		get_prioritized_modules()
		pull_directive()
	
	
	func get_prioritized_modules() -> void:
		modules = []
		var weights = {}
		
		match role:
			"offense":
				for first in god.opponent.framework.doublets:
					for second in god.opponent.framework.doublets[first]:
						var _doublet = god.opponent.framework.doublets[first][second]
						var weight = 1
						
						if !weights.has(_doublet.grids):
							weights[_doublet.grids] = weight
				
				var grids = Global.get_random_key(weights)
				
				for grid in grids:
					var module = god.opponent.framework.grids[grid]
					modules.append(module)
			"defense":
				var datas = []
				
				for target in clash.aim.targets.get_children():
					var data = {}
					data.module = target.module
					data.weight = 1
					datas.append(data)
				
				datas.shuffle()
				datas.sort_custom(func(a, b): return a.weight < b.weight)
				
				for _i in Global.num.doublet.n:
					var module = datas[_i].module
					modules.append(module)
	
	
	func pull_directive() -> void:
		var grids = []
		
		for module in modules:
			grids.append(module.grid)
		
		var _doublet = god.framework.doublets[grids.front()][grids.back()]
		directive = _doublet.directives[role].pick_random()
		directive.set_as_active()
		axis = null
		
		for _grids in directive.grids:
			if axis == null:
				for grid in _grids:
					if grids.has(grid):
						axis = _grids.front()
						break
	
	
	func spread_impacts() -> void:
		var limit = god.library.impact.get_value()
		var percent = float(limit) / 100
		var weights = {}
		var opportunities = {}
		
		match role:
			"offense":
				var minimum = floor(limit * Global.num.target.min)
				
				for type in Global.arr.target:
					var target = clash.aim.get(type)
					weights[target] = 1
					var impact = target.get(role)
					impact.change_value(minimum)
					limit -= minimum
					
					var distribution = directive.get_token(type, "distribution").get_value()
					opportunities[type] = floor(percent * distribution) - minimum
				
				while limit > 0 or opportunities.keys().is_empty():
					var target = Global.get_random_key(weights)
					var impact = target.get(role)
					var _max = min(opportunities[target.type] / 2, limit)
					Global.rng.randomize()
					var value = Global.rng.randi_range(1, _max)
					limit -= value
					opportunities[target.type] -= value
					impact.change_value(value)
					
					if opportunities[target.type] == 0:
						opportunities.erase(target.type)
						weights.erase(target)
			"defense":
				var targets = clash.aim.targets.get_children()
				var _axis = targets[0].module.grid
				var grids = directive.get_grids_based_on_axis(_axis)
				
				for target in targets:
					if grids.has(target.module.grid):
						var impact = target.get("offense")
						var goal = impact.get_value()
						var distribution = directive.get_token(target.type, "distribution").get_value()
						opportunities[target.type] = floor(percent * distribution)
						
						if opportunities[target.type] >= goal and limit >= goal:
							impact = target.get(role)
							impact.change_value(goal)
							limit -= goal
					


class Doublet:
	var framework = null
	var grids = null
	var directives = {}


	func _init(input_: Dictionary) -> void:
		framework = input_.framework
		grids = input_.grids
	
		init_basic_setting()


	func init_basic_setting() -> void:
		for role in Global.arr.role:
			directives[role] = []
		
		if !framework.doublets.has(grids.front()):
			framework.doublets[grids.front()] = {}
		
		if !framework.doublets.has(grids.back()):
			framework.doublets[grids.back()] = {}
		
		framework.doublets[grids.front()][grids.back()] = self
		framework.doublets[grids.back()][grids.front()] = self
