extends MarginContainer


#region var
@onready var vertexs = $HBox/MarginContainer/Vertexs
@onready var faces = $HBox/MarginContainer/Faces
@onready var metal = $HBox/Amplifiers/Metal
@onready var liquid = $HBox/Amplifiers/Liquid
@onready var energy = $HBox/Amplifiers/Energy
@onready var evasion = $HBox/Aspects/Evasion
@onready var accuracy = $HBox/Aspects/Accuracy
@onready var critical = $HBox/Aspects/Critical

var god = null
var framework = null
var grids = {}
var values = {}
var throws = {}
var liaisons = {}
var throw = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	god = input_.god
	
	init_basic_setting()


func init_basic_setting() -> void:
	init_tokens()


func init_tokens() -> void:
	init_amplifiers()
	init_aspects()
	init_vertexs()
	init_faces()
	init_throws()


func init_amplifiers() -> void:
	for resource in Global.arr.resource:
		var token = get(resource)
		var input = {}
		input.proprietor = self
		input.type = "resource"
		input.subtype = resource
		input.value = 1.0
		token.set_attributes(input)


func init_aspects() -> void:
	for aspect in Global.arr.aspect:
		var token = get(aspect)
		var input = {}
		input.proprietor = self
		input.type = "aspect"
		input.subtype = aspect
		input.value = Global.num.aspect[aspect]
		token.set_attributes(input)


func init_vertexs() -> void:
	vertexs.set("theme_override_constants/h_separation", Global.num.offset.vertex)
	vertexs.set("theme_override_constants/v_separation", Global.num.offset.vertex)
	grids.vertex = {}
	liaisons.vertex = {}
	
	for _i in Global.num.core.n:
		for _j in Global.num.core.n:
			var grid = Vector2i(_j, _i)
			add_vertex(grid)


func add_vertex(grid_: Vector2i) -> void:
	var input = {}
	input.proprietor = self
	input.type = "vertex"
	input.subtype = str(0)
	input.value = Global.dict.core.grid[grid_]
	
	var token = Global.scene.token.instantiate()
	vertexs.add_child(token)
	token.set_attributes(input)
	grids.vertex[grid_] = token
	
	if !values.has(input.value):
		values[input.value] = []
	
	values[input.value].append(token)
	liaisons.vertex[token] = []
	token.set_bg_color(Global.color.vertex.disabled)


func init_faces() -> void:
	faces.set("theme_override_constants/h_separation", Global.num.offset.face)
	faces.set("theme_override_constants/v_separation", Global.num.offset.face)
	grids.face = {}
	liaisons.face = {}
	var subtypes = roll_subtypes()
	
	for _i in Global.num.core.n - 1:
		for _j in Global.num.core.n - 1:
			var grid = Vector2i(_j, _i)
			add_face(grid, subtypes[grid])
			#print(grid, subtypes[grid])


func roll_subtypes() -> Dictionary:
	var description = {}
	description.cols = []
	description.rows = []
	description.grids = []
	description.subtypes = {}
	description.resources = []
	
	var resource = Global.arr.resource.pick_random()
	
	for _i in Global.num.core.n - 1:
		description.resources.append_array(Global.arr.resource)
	
	description.resources.shuffle()
	
	for _i in Global.num.core.n - 1:
		description.resources.erase(resource)
	
	for _i in Global.num.core.n - 1:
		description.resources.insert(0, resource)
	
	for _i in Global.num.core.n - 1:
		description.cols.append([])
		description.rows.append([])
		
		for _j in Global.num.core.n - 1:
			var grid = Vector2i(_j, _i)
			description.grids.append(grid)
	
	description.grids.shuffle()
	
	while !description.grids.is_empty():
		roll_grid(description, null)
	
	return description.subtypes


func roll_grid(description_: Dictionary, grid_: Variant) -> void:
	var resource = description_.resources.pop_front()
	var options = []
	var grid = grid_
	
	if grid_ == null:
		for _grid in description_.grids:
			if !description_.cols[_grid.x].has(resource) and !description_.rows[_grid.y].has(resource):
				options.append(_grid)
		
		grid = options.pick_random()
	
	if grid == null:
		pass
	
	description_.grids.erase(grid)
	description_.subtypes[grid] = resource
	
	if !description_.cols[grid.x].has(resource):
		description_.cols[grid.x].append(resource)
		
	if !description_.rows[grid.y].has(resource):
		description_.rows[grid.y].append(resource)
	
	
	set_all_last_ones(description_)


func set_all_last_ones(description_: Dictionary) -> void:
	for col in description_.cols:
		if col.size() == Global.num.core.n - 2:
			var index = description_.cols.find(col)
			var grid = get_last_one_grid(description_, "col", index)
			
			if description_.grids.has(grid):
				roll_grid(description_, grid)
				return
	
	for row in description_.rows:
		if row.size() == Global.num.core.n - 2:
			var index = description_.rows.find(row)
			var grid = get_last_one_grid(description_, "row", index)
			
			if description_.grids.has(grid):
				roll_grid(description_, grid)
				return


func get_last_one_grid(description_: Dictionary, type_: String, index_: int) -> Variant:
	var donor = description_[type_+"s"][index_]
	
	for _i in Global.num.core.n - 1:
		var grid = Vector2i(_i, _i)
		
		match type_:
			"col":
				grid.x = index_
			"row":
				grid.y = index_
		
		if !donor.has(grid):
			if description_.grids.has(grid):
				var resource = get_last_one_resource(description_, grid)
				description_.resources.erase(resource)
				description_.resources.insert(0, resource)
				return grid
	
	return null

#
#func get_last_one_grids(description_: Dictionary, resource_: String) -> Array:
	#var options = []
	#
	#for col in description_.cols:
		#if col.size() == Global.num.core.n - 2 and !col.has(resource_):
			#var index = description_.cols.find(col)
			#var grid = get_last_one_grid(description_, "col", index)
			#options.append(grid)
	#
	#for row in description_.rows:
		#if row.size() == Global.num.core.n - 2 and !row.has(resource_):
			#var index = description_.rows.find(row)
			#var grid = get_last_one_grid(description_, "row", index)
			#options.append(grid)
	#
	#return options


func get_last_one_resource(description_: Dictionary, grid_: Vector2i) -> Variant:
	var options = []
	options.append_array(Global.arr.resource)
	
	for grid in description_.subtypes:
		if grid.x == grid_.x or grid.y == grid_.y:
			options.erase(description_.subtypes[grid])
	
	if options.size() == 1:
		return options.front()
	
	return null


func add_face(grid_: Vector2i, subtype_: String) -> void:
	var input = {}
	input.proprietor = self
	input.type = "resource"
	input.subtype = subtype_
	
	var token = Global.scene.token.instantiate()
	faces.add_child(token)
	token.set_attributes(input)
	
	grids.face[grid_] = token
	liaisons.face[token] = []
	
	for direction in Global.dict.direction.zero:
		var _grid = grid_ + direction
		var vertex = grids.vertex[_grid]
		liaisons.face[token].append(vertex)
		liaisons.vertex[vertex].append(token)


func init_throws() -> void:
	var facets = []
	
	for _i in Global.num.throw.facets:
		facets.append(_i + 1)
	
	for _i in facets:
		for _j in facets:
			var sum = _i + _j
			
			if !throws.has(sum):
				throws[sum] = 0
			
			throws[sum] += 1
	
	throws.erase(Global.num.throw.exception)



#endregion


func reset() -> void:
	if throw != null:
		var _vertexs = values[throw]
		
		for vertex in _vertexs:
			vertex.set_bg_color(Global.color.vertex.disabled)
	
	for resource in Global.arr.resource:
		var amplifier = get(resource)
		amplifier.set_value(1)


func roll_amplifiers() -> void:
	reset()
	throw = Global.get_random_key(throws)
	var _vertexs = values[throw]
	var value = Global.num.resource.amplifier
	
	if Global.arr.throw.has(throw):
		value *= 2
	
	for vertex in _vertexs:
		vertex.set_bg_color(Global.color.vertex.actived)
		
		for face in liaisons.vertex[vertex]:
			var resource = face.designation.subtype
			var amplifier = get(resource)
			amplifier.change_value(value)


func get_amplifier_value(resource_: String) -> float:
	var amplifier = get(resource_)
	return amplifier.get_value()
