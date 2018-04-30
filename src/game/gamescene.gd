extends Spatial

func _ready():

	var s = ResourceLoader.load("res://src/game/player/player3d.tscn")

	add_child(s.instance())
	
	var file = File.new()
	file.open("res://assets/levels/level.json", file.READ)
	var text = file.get_as_text()
	
	var levelData = parse_json(text)
	file.close()
	
	print(levelData["name"] + " is loaded from level.json")
	
	var obstacle = ResourceLoader.load("res://src/game/env/obstacle.tscn")
	
	for i in levelData["obstacles"]["p"]:
		var inst = obstacle.instance()
		inst.translate(Vector3(2 * i, 0, -4))
		add_child(inst) # not batched

	var instObstacle = ResourceLoader.load("res://src/game/env/instanced_obstacle.tscn")
	var inst = instObstacle.instance()
	inst.multimesh.instance_count = 2;
	inst.multimesh.set_instance_transform(0, Transform().translated(Vector3(0, 2, 0)))
	inst.multimesh.set_instance_transform(1, Transform().translated(Vector3(0, -2, 0)))
	add_child(inst) # batched
	
	#self.material.set_shader_param("my_value", 0.5)

	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
