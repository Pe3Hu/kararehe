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
	arr.orientation = ["nexus", "axis", "center", "corner"]
	
	arr.resource = ["energy", "metal", "liquid"]
	arr.damage = ["blind shell", "fire", "explosion", "acid", "electricity", "laser"]
	arr.gem = ["diamond", "ruby", "amber", "emerald", "sapphire", "amethyst"]
	arr.condition = ["orientation", "gear"]
	arr.sign = ["less", "equal", "more"]
	arr.restriction = [0, 1, 2]
	arr.throw = [6, 8]
	arr.aspect = ["evasion", "accuracy", "critical"]
	#arr.offense = ["boost", "targeting", "readiness"]
	#arr.defense = ["agility", "fortification", "nanite", "stealth"]
	#arr.attenuation = ["weakness", "blindness", "hindrance", "vulnerability", "erosion"]


func init_num() -> void:
	num.index = {}
	num.index.god = 0
	
	num.framework = {}
	num.framework.k = 2
	num.framework.n = num.framework.k * 2 + 1
	
	num.module = {}
	num.module.a = 48
	num.module.r = num.module.a / sqrt(2)
	
	num.core = {}
	num.core.n = 4
	
	num.offset = {}
	num.offset.vertex = 8
	num.offset.face = 8
	
	num.pattern = {}
	num.pattern.rotations = 4
	
	num.gem = {}
	num.gem.durability = 60
	num.gem.nexus = num.gem.durability * 10
	
	num.throw = {}
	num.throw.facets = 6
	num.throw.exception = 7
	
	num.resource = {}
	num.resource.amplifier = 0.2
	
	num.purpose = {}
	num.purpose.min = 1
	num.purpose.max = 3
	
	num.aspect = {}
	num.aspect.evasion = 5
	num.aspect.accuracy = 95
	num.aspect.critical = 5


func init_dict() -> void:
	init_direction()
	init_font()
	
	init_framework()
	init_resource()
	init_core()
	init_gem()
	init_purpose()
	init_vulnerability()
	init_pattern()
	init_weapon()
	init_status()


func init_direction() -> void:
	dict.direction = {}
	dict.direction.linear = [
		Vector2i( 0,-1),
		Vector2i( 1, 0),
		Vector2i( 0, 1),
		Vector2i(-1, 0)
	]
	dict.direction.diagonal = [
		Vector2i( 1,-1),
		Vector2i( 1, 1),
		Vector2i(-1, 1),
		Vector2i(-1,-1)
	]
	dict.direction.zero = [
		Vector2i( 0, 0),
		Vector2i( 1, 0),
		Vector2i( 1, 1),
		Vector2i( 0, 1)
	]


func init_font() -> void:
	dict.font = {}
	dict.font.size = {}
	dict.font.size["basic"] = 15
	dict.font.size["module"] = 18


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
	
	
	dict.fuel = {}
	dict.fuel.damage = {}
	dict.fuel.damage["laser"] = "energy"
	dict.fuel.damage["electricity"] = "energy"
	dict.fuel.damage["blind shell"] = "metal"
	dict.fuel.damage["explosion"] = "metal"
	dict.fuel.damage["fire"] = "liquid"
	dict.fuel.damage["acid"] = "liquid"
	
	dict.fuel.resource = {}


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
	
	var path = "res://asset/json/kararehe_core.json"
	var array = load_data(path)
	
	for core in array:
		var words = {}
		words.primary = core.title.split(" ")
		var y = int(words.primary[1])
		
		for key in core:
			if !exceptions.has(key):
				words.secondary = key.split(" ")
				var x = int(words.secondary[1])
				var grid = Vector2i(x, y)
				
				dict.core.grid[grid] = int(core[key])


func init_gem() -> void:
	dict.gem = {}
	dict.gem.grid = {}
	dict.gem.gear = {}
	var exceptions = ["title"]
	
	var path = "res://asset/json/kararehe_gem.json"
	var array = load_data(path)
	
	for gem in array:
		var words = {}
		words.primary = gem.title.split(" ")
		var y = int(words.primary[1])
		
		if !dict.gem.gear.has(y):
			dict.gem.gear[y] = []
		
		for key in gem:
			if !exceptions.has(key):
				words.secondary = key.split(" ")
				var x = int(words.secondary[1])
				var grid = Vector2i(x, y)
				
				dict.gem.grid[grid] = gem[key]
				
				dict.gem.gear[y].append(gem[key])


func init_purpose() -> void:
	dict.purpose = {}
	dict.purpose.title = {}
	dict.purpose.resource = {}
	var exceptions = ["title"]
	
	var path = "res://asset/json/kararehe_purpose.json"
	var array = load_data(path)
	
	for purpose in array:
		var data = {}
		
		for key in purpose:
			if !exceptions.has(key):
				data[key] = purpose[key]
	
		dict.purpose.title[purpose.title] = data
		
		if !dict.purpose.resource.has(purpose.resource):
			dict.purpose.resource[purpose.resource] = []
		
		dict.purpose.resource[purpose.resource].append(purpose.title)


func init_vulnerability() -> void:
	dict.vulnerability = {}
	dict.vulnerability.damage = {}
	var exceptions = ["title"]
	
	var path = "res://asset/json/kararehe_vulnerability.json"
	var array = load_data(path)
	
	for vulnerability in array:
		var data = {}
		
		for key in vulnerability:
			if !exceptions.has(key):
				data[key] = float(vulnerability[key]) / 100
	
		dict.vulnerability.damage[vulnerability.title] = data


func init_pattern() -> void:
	dict.damage = {}
	dict.damage.pattern = {}
	
	dict.pattern = {}
	dict.pattern.title = {}
	dict.pattern.rotations = {}
	dict.pattern.reflections = {}
	dict.pattern.turns = {}
	var exceptions = ["title"]
	
	var path = "res://asset/json/kararehe_pattern.json"
	var array = load_data(path)
	
	for pattern in array:
		var data = {}
		pattern.size = int(pattern.size)
		data.directions = []
		
		for key in pattern:
			if !exceptions.has(key):
				if key.contains("direction"):
					var direction = str_to_var(pattern[key])
					data.directions.append(direction)
				else:
					if key == "damages":
						var words = pattern[key].split(",")
						data[key] = words
					else:
						data[key] = pattern[key]
	
		dict.pattern.title[pattern.title] = data
		
		if !dict.damage.pattern.has(pattern.size):
			dict.damage.pattern[pattern.size] = {}
		
		if data.has("damages"):
			for damage in data.damages:
				if !dict.damage.pattern[pattern.size].has(damage):
					dict.damage.pattern[pattern.size][damage] = []
				
				dict.damage.pattern[pattern.size][damage].append(pattern.title)
	
	for letter in dict.pattern.title:
		dict.pattern.rotations[letter] = []
		dict.pattern.turns[letter] = []
		
		if dict.pattern.title[letter].variation != "none":
			for _i in num.pattern.rotations:
				var rotations = []
				var angle = PI * 2 / num.pattern.rotations * _i
				
				for direction in dict.pattern.title[letter].directions:
					var rotation = Vector2(direction).rotated(angle)
					rotations.append(Vector2i(rotation))
				
				dict.pattern.rotations[letter].append(rotations)
				dict.pattern.turns[letter].append(rotations)
		else:
			dict.pattern.rotations[letter].append(dict.pattern.title[letter].directions)
		
		
		if dict.pattern.title[letter].variation == "reflection":
			dict.pattern.reflections[letter] = []
			
			for directions in dict.pattern.rotations[letter]:
				var reflections = []
				
				for direction in directions:
					var reflection = Vector2i(-direction.x, direction.y)
					reflections.append(reflection)
				
				dict.pattern.reflections[letter].append(reflections)
				dict.pattern.turns[letter].append(reflections)
	
	dict.pattern.turns["a"].append(dict.pattern.title["a"].directions)


func init_weapon() -> void:
	dict.weapon = {}
	dict.weapon.index = {}
	dict.weapon.damage = {}
	var exceptions = ["index"]
	
	var path = "res://asset/json/kararehe_weapon.json"
	var array = load_data(path)
	
	for weapon in array:
		weapon.index = int(weapon.index)
		var data = {}
		data.powers = {}
		data.avg = float(0)
		
		for key in weapon:
			if !exceptions.has(key):
				
				if key.contains("power"):
					var words = key.split(" ")
					data.powers[words[1]] = weapon[key]
					data.avg += weapon[key]
				else:
					data[key] = weapon[key]
		
		data.avg /= 2
		
		dict.weapon.index[weapon.index] = data
		
		if !dict.weapon.damage.has(weapon.damage):
			dict.weapon.damage[weapon.damage] = []
		
		dict.weapon.damage[weapon.damage].append(weapon.index)


func init_status() -> void:
	dict.status = {}
	dict.status.title = {}
	dict.status.type = {}
	dict.status.subtype = {}
	var exceptions = ["title"]
	
	var path = "res://asset/json/kararehe_status.json"
	var array = load_data(path)
	
	for status in array:
		var data = {}
		
		for key in status:
			if !exceptions.has(key):
				data[key] = status[key]
	
		dict.status.title[status.title] = data
		
		if !dict.status.type.has(status.type):
			dict.status.type[status.type] = []
		
		dict.status.type[status.type].append(status.title)
		
		if !dict.status.subtype.has(status.subtype):
			dict.status.subtype[status.subtype] = []
		
		dict.status.subtype[status.subtype].append(status.title)
	
	#var types = ["offense", "defense", "attenuation"]
	#dict.generator = {}
	#dict.generator.effect = {}
	#
	#for type in types:
		#for effect in arr[type]:
			#dict.generator.effect[effect] = type


func init_scene() -> void:
	scene.token = load("res://scene/0/token.tscn")
	
	scene.pantheon = load("res://scene/1/pantheon.tscn")
	scene.god = load("res://scene/1/god.tscn")
	
	scene.planet = load("res://scene/2/planet.tscn")
	
	scene.module = load("res://scene/3/module.tscn")
	scene.generator = load("res://scene/3/generator.tscn")
	
	scene.weapon = load("res://scene/4/weapon.tscn")
	
	scene.pointer = load("res://scene/5/pointer.tscn")


func init_vec():
	vec.size = {}
	vec.size.sixteen = Vector2(16, 16)
	
	vec.size.token = Vector2(vec.size.sixteen * 2)
	vec.size.module = Vector2.ONE * num.module.a
	vec.size.clash = Vector2(vec.size.module)
	
	
	vec.size.pattern = Vector2(64, 32)
	vec.size.generator = Vector2(vec.size.module) * 0.5
	
	vec.size.bar = Vector2(vec.size.generator.x * 2, vec.size.generator.y * 0.25)
	
	init_window_size()


func init_window_size():
	vec.size.window = {}
	vec.size.window.width = ProjectSettings.get_setting("display/window/size/viewport_width")
	vec.size.window.height = ProjectSettings.get_setting("display/window/size/viewport_height")
	vec.size.window.center = Vector2(vec.size.window.width/2, vec.size.window.height/2)


func init_color():
	var h = 360.0
	
	color.module = {}
	color.module.head = Color.from_hsv(60 / h, 0.6, 0.7)
	color.module.limb = Color.from_hsv(210 / h, 0.6, 0.7)
	color.module.torso = Color.from_hsv(330 / h, 0.6, 0.7)
	
	color.specialization = {}
	color.specialization.lethality = Color.from_hsv(0 / h, 0.6, 0.7)
	color.specialization.sensory = Color.from_hsv(60 / h, 0.6, 0.7)
	color.specialization.mobility = Color.from_hsv(120 / h, 0.6, 0.7)
	color.specialization.durability = Color.from_hsv(210 / h, 0.6, 0.7)
	
	color.vertex = {}
	color.vertex.actived = Color.from_hsv(120 / h, 0.8, 0.7)
	color.vertex.disabled = Color.from_hsv(210 / h, 0.2, 0.7)
	
	color.indicator = {}
	color.indicator.generation = {}
	color.indicator.generation.fill = Color.from_hsv(30 / h, 0.9, 0.7)
	color.indicator.generation.background = Color.from_hsv(30 / h, 0.5, 0.9)


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
