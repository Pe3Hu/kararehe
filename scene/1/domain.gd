extends MarginContainer


#region vars
var god = null

var areas = {}
var borderlands = []
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	god = input_.god
	
	init_basic_setting()


func init_basic_setting() -> void:
	pass


func roll_areas() -> void:
	if true:
		return 
	
	var continent = god.planet.continent
	var rank = god.planet.rank
	var territories = Global.dict.territory.rank[rank].duplicate()
	var n = rank + 1
	
	var parent = continent.corners.pick_random()
	var direction = continent.center - parent.grid
	var l = abs(direction.x)
	#direction = direction.limit_length(sqrt(2))
	direction /= l
	areas[parent] = []
	territories[1] -= 1
	
	for _i in n:
		var child = parent.directions[direction]
		areas[child] = [parent]
		areas[parent].append(child)
		
		for area in child.neighbors.diagonal:
			if !areas.has(area) and !borderlands.has(area):
				borderlands.append(area)
		
		if borderlands.has(child):
			borderlands.erase(child)
		
		parent = child
		territories[1] -= 1
	
	var lengths = []
	
	while !territories.keys().is_empty():
		if lengths.is_empty():
			lengths = territories.keys()
		
		var length = lengths.pick_random()
		var datas = []
		
		for area in borderlands:
			for _direction in Global.dict.neighbor.linear:
				var data = {}
				data.areas = [area]
				data.direction = _direction
				var flag = true
				
				for _i in length-1:
					var _area = data.areas.back()
					
					if _area.directions.has(_direction):
						_area = _area.directions[_direction]
						
						for neighbor in _area.neighbors.linear:
							if areas.has(neighbor):
								flag = false
								break
					else:
						flag = false
					
					if flag:
						data.areas.append(_area)
				
				if data.areas.size() == length:
					datas.append(data)
		
		if !datas.is_empty():
			var data = datas.pick_random()
			borderlands.erase(data.areas.front())
			
			for area in data.areas:
				areas[area] = []
				
				for neighbor in area.neighbors.diagonal:
					if areas.has(neighbor):
						areas[area].append(neighbor)
						areas[neighbor].append(area)
				
				for neighbor in area.neighbors.linear:
					if borderlands.has(neighbor):
						borderlands.erase(neighbor)
			
			var edges = [data.areas.front(), data.areas.back()]
			
			if length == 1:
				edges.pop_back()
			
			for edge in edges:
				for area in edge.neighbors.diagonal:
					if !areas.has(area):
						var flag = true
						
						for neighbor in area.neighbors.linear:
							if areas.has(neighbor):
								flag = false
								break
						
						if flag:
							borderlands.append(area)
			
			territories[length] -= 1
			
			if territories[length] == 0:
				territories.erase(length)
				lengths.erase(length)
		else:
			lengths.erase(length)
	
	for area in areas:
		area.domains.append(self)
	#	area.recolor_based_on_domain(self)
#endregion
