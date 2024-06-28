extends Node


var rng = RandomNumberGenerator.new()
var arr = {}
var num = {}
var vec = {}
var color = {}
var dict = {}
var flag = {}
var node = {}
var scene = {}


func _ready() -> void:
	init_arr()
	init_num()
	init_vec()
	init_color()
	init_dict()
	init_scene()


func init_arr() -> void:
	arr.gear = ["head", "limb", "torso"]
	arr.role = ["offense", "defense"]
	arr.axis = ["first", "second", "third", "fourth"]
	
	arr.resource = ["energy", "metal", "liquid"]


func init_num() -> void:
	num.index = {}
	num.index.god = 0
	
	num.framework = {}
	num.framework.k = 2
	num.framework.n = num.framework.k * 2 + 1
	
	num.module = {}
	num.module.a = 36
	num.module.r = num.module.a / sqrt(2)
	
	num.core = {}
	num.core.n = 4


func init_dict() -> void:
	init_neighbor()
	init_font()
	
	init_framework()
	init_resource()
	init_core()


func init_neighbor() -> void:
	dict.neighbor = {}
	dict.neighbor.linear = [
		Vector2i( 0,-1),
		Vector2i( 1, 0),
		Vector2i( 0, 1),
		Vector2i(-1, 0)
	]
	dict.neighbor.diagonal = [
		Vector2i( 1,-1),
		Vector2i( 1, 1),
		Vector2i(-1, 1),
		Vector2i(-1,-1)
	]
	dict.neighbor.zero = [
		Vector2i( 0, 0),
		Vector2i( 1, 0),
		Vector2i( 1, 1),
		Vector2i( 0, 1)
	]


func init_font() -> void:
	dict.font = {}
	dict.font.size = {}
	dict.font.size["basic"] = 18
	dict.font.size["season"] = 18
	dict.font.size["phase"] = 18
	dict.font.size["moon"] = 18


func init_resource() -> void:
	dict.resource = {}
	dict.resource.title = {}
	var exceptions = ["title"]
	
	var path = "res://asset/json/kararehe_resource.json"
	var array = load_data(path)
	
	for resource in array:
		var data = {}
		
		for key in resource:
			if !exceptions.has(key):
				data[key] = resource[key]
	
		dict.resource.title[resource.title] = data


func init_framework() -> void:
	dict.framework = {}
	dict.framework.title = {}
	var exceptions = ["title"]
	exceptions.append_array(arr.gear)
	
	var path = "res://asset/json/kararehe_framework.json"
	var array = load_data(path)
	
	for framework in array:
		var data = {}
		data.gears = {}
		data.circuits = {}
		
		for key in framework:
			if !exceptions.has(key):
				var index = int(framework[key])
				
				if !data.circuits.has(index):
					data.circuits[index] = []
				
				data.circuits[index].append(int(key))
			else:
				if arr.gear.has(key):
					var circuits = framework[key].split(",")
					
					for circuit in circuits:
						data.gears[int(circuit)] = key
	
		dict.framework.title[framework.title] = data


func init_core() -> void:
	dict.core = {}
	dict.core.grid = {}
	var exceptions = ["title"]
	var pair = ["row", "col"]
	
	var path = "res://asset/json/kararehe_core.json"
	var array = load_data(path)
	
	for core in array:
		var words = {}
		words.primary = core.title.split(" ")
		var y = int(words.primary[1])
		var data = {}
		
		for key in core:
			if !exceptions.has(key):
				words.secondary = key.split(" ")
				var x = int(words.secondary[1])
				var grid = Vector2i(x, y)
				
				dict.core.grid[grid] = core[key]


func init_scene() -> void:
	scene.token = load("res://scene/0/token.tscn")
	
	scene.pantheon = load("res://scene/1/pantheon.tscn")
	scene.god = load("res://scene/1/god.tscn")
	
	scene.planet = load("res://scene/2/planet.tscn")
	
	scene.module = load("res://scene/3/module.tscn")


func init_vec():
	vec.size = {}
	vec.size.sixteen = Vector2(16, 16)
	
	vec.size.token = Vector2(vec.size.sixteen * 2)
	vec.size.module = Vector2.ONE * num.module.a
	vec.size.specialization = vec.size.module# * 1.25
	vec.size.software = Vector2(vec.size.specialization)
	vec.size.directive = Vector2(vec.size.specialization)# * 1.25
	vec.size.clash = Vector2(vec.size.module)
	vec.size.target = Vector2(vec.size.module)
	vec.size.circuit = Vector2(vec.size.module)
	vec.size.chip = Vector2(vec.size.module)
	
	
	vec.size.bar = Vector2(num.module.a / 2, num.module.a * num.framework.n)
	
	
	init_window_size()


func init_window_size():
	vec.size.window = {}
	vec.size.window.width = ProjectSettings.get_setting("display/window/size/viewport_width")
	vec.size.window.height = ProjectSettings.get_setting("display/window/size/viewport_height")
	vec.size.window.center = Vector2(vec.size.window.width/2, vec.size.window.height/2)


func init_color():
	var h = 360.0
	
	color.module = {}
	color.module.head = Color.from_hsv(330 / h, 0.6, 0.7)
	color.module.limb = Color.from_hsv(300 / h, 0.6, 0.7)
	color.module.torso = Color.from_hsv(270 / h, 0.6, 0.7)
	
	color.specialization = {}
	color.specialization.lethality = Color.from_hsv(0 / h, 0.6, 0.7)
	color.specialization.sensory = Color.from_hsv(60 / h, 0.6, 0.7)
	color.specialization.mobility = Color.from_hsv(120 / h, 0.6, 0.7)
	color.specialization.durability = Color.from_hsv(210 / h, 0.6, 0.7)
	
	color.impact = {}
	color.impact.offense = {}
	color.impact.offense.maximum = Color.from_hsv(0 / h, 0.7, 1.0)
	color.impact.offense.minimum = Color.from_hsv(0 / h, 0.7, 0.6)
	color.impact.defense = {}
	color.impact.defense.maximum = Color.from_hsv(210 / h, 0.7, 1.0)
	color.impact.defense.minimum = Color.from_hsv(210 / h, 0.7, 0.6)
	
	color.summand = {}
	color.summand.spread = Color.from_hsv(180 / h, 0.55, 0.6)
	color.summand.amplifier = Color.from_hsv(330 / h, 0.55, 0.6)
	
	color.indicator = {}
	color.indicator.energy = {}
	color.indicator.energy.fill = Color.from_hsv(30 / h, 0.9, 0.7)
	color.indicator.energy.background = Color.from_hsv(30 / h, 0.5, 0.9)


func save(path_: String, data_: String):
	var path = path_ + ".json"
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(data_)


func load_data(path_: String):
	var file = FileAccess.open(path_, FileAccess.READ)
	var text = file.get_as_text()
	var json_object = JSON.new()
	var _parse_err = json_object.parse(text)
	return json_object.get_data()


func get_random_key(dict_: Dictionary):
	if dict_.keys().size() == 0:
		print("!bug! empty array in get_random_key func")
		return null
	
	var total = 0
	
	for key in dict_.keys():
		total += dict_[key]
	
	rng.randomize()
	var index_r = rng.randf_range(0, 1)
	var index = 0
	
	for key in dict_.keys():
		var weight = float(dict_[key])
		index += weight/total
		
		if index > index_r:
			return key
	
	print("!bug! index_r error in get_random_key func")
	return null


func get_all_constituents(array_: Array) -> Dictionary:
	var constituents = {}
	constituents[0] = []
	constituents[1] = []
	
	for child in array_:
		constituents[0].append(child)
		constituents[1].append([child])
	
	for _i in array_.size()-2:
		set_constituents_based_on_size(constituents, _i+2)
	
	constituents[array_.size()] = [constituents[0]]
	constituents.erase(0)
	return constituents


func set_constituents_based_on_size(constituents_: Dictionary, size_: int) -> void:
	var parents = constituents_[size_-1]
	constituents_[size_] = []
	
	for parent in parents:
		for child in constituents_[0]:
			if !parent.has(child):
				var constituent = []
				constituent.append_array(parent)
				constituent.append(child)
				constituent.sort_custom(func(a, b): return constituents_[0].find(a) < constituents_[0].find(b))
				
				if !constituents_[size_].has(constituent):
					constituents_[size_].append(constituent)


func get_all_constituents_based_on_size(array_: Array, size_: int) -> Array:
	var constituents = {}
	constituents[0] = []
	constituents[1] = []
	
	for child in array_:
		constituents[0].append(child)
		constituents[1].append([child])
	
	for _i in array_.size()-2:
		set_constituents_based_on_size(constituents, _i+2)
		
		if constituents.keys().size() == size_ + 1:
			return constituents[size_]
	
	return constituents[constituents.keys().size() - 1]
