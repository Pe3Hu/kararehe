extends MarginContainer


#region var
@onready var vertexs = $Vertexs
@onready var faces = $Faces

var god = null
var framework = null
var grids = {}
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	god = input_.god
	
	init_basic_setting()


func init_basic_setting() -> void:
	init_tokens()


func init_tokens() -> void:
	init_vertexs()
	init_faces()


func init_vertexs() -> void:
	grids.vertex = {}
	
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


func init_faces() -> void:
	grids.face = {}
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
	description.resources.append_array(Global.arr.resource)
	description.resources.shuffle()
	
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


func roll_grid(description_: Dictionary, resource_: Variant) -> void:
	var resource = resource_
	var options = []
	
	if resource_ == null:
		resource = description_.resources.front()
	
		for _grid in description_.grids:
			if !description_.cols[_grid.x].has(resource) and !description_.rows[_grid.y].has(resource):
				options.append(_grid)
	else:
		options = get_last_ones(description_, resource_)
		
	var grid = options.pick_random()
	
	if grid == null:
		pass
	
	description_.grids.erase(grid)
	description_.subtypes[grid] = resource
	
	if !description_.cols[grid.x].has(resource):
		description_.cols[grid.x].append(resource)
		
	if !description_.rows[grid.y].has(resource):
		description_.rows[grid.y].append(resource)
	
	if options.size() == 1:
		description_.resources.erase(resource)
	
	#set_last_one(description_)


func set_last_one(description_: Dictionary) -> void:
	for col in description_.cols:
		if col.size() == Global.num.core.n - 2:
			var index = description_.cols.find(col)
			var grid = get_last_one(description_, "col", index)
			roll_grid(description_, grid)
	
	for row in description_.rows:
		if row.size() == Global.num.core.n - 2:
			var index = description_.rows.find(row)
			var grid = get_last_one(description_, "row", index)
			roll_grid(description_, grid)


func get_last_one(description_: Dictionary, type_: String, index_: int) -> Vector2i:
	var donor = description_[type_+"s"][index_]
	
	for _i in Global.num.core.n - 1:
		var grid = Vector2i(_i, _i)
		
		match type_:
			"col":
				grid.x = index_
			"row":
				grid.y = index_
		
		if !donor.has(grid):
			return grid
	
	return -Vector2i.ONE


func get_last_ones(description_: Dictionary, resource_: String) -> Array:
	var options = []
	
	for col in description_.cols:
		if col.size() == Global.num.core.n - 2 and !col.has(resource_):
			var index = description_.cols.find(col)
			var grid = get_last_one(description_, "col", index)
			options.append(grid)
	
	for row in description_.rows:
		if row.size() == Global.num.core.n - 2 and !row.has(resource_):
			var index = description_.rows.find(row)
			var grid = get_last_one(description_, "row", index)
			options.append(grid)
	
	return options


func add_face(grid_: Vector2i, subtype_: String) -> void:
	var input = {}
	input.proprietor = self
	input.type = "resource"
	input.subtype = subtype_
	
	var token = Global.scene.token.instantiate()
	faces.add_child(token)
	token.set_attributes(input)
	grids.face[grid_] = token
#endregion
