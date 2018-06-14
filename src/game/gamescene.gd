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
		inst.translate(Vector3(2 * i - 2.6, -1.0, -3))
		add_child(inst) # not batched

	var instObstacle = ResourceLoader.load("res://src/game/env/instanced_obstacle.tscn")
	var inst = instObstacle.instance()
	inst.multimesh.instance_count = 2;
	inst.multimesh.set_instance_transform(0, Transform().translated(Vector3(0, 2, -14)))
	inst.multimesh.set_instance_transform(1, Transform().translated(Vector3(4, 2, -14)))
	add_child(inst) # batched
	
	#self.material.set_shader_param("my_value", 0.5)
	
	get_node("ResetButton").connect("pressed", self, "_on_reset_button_pressed")
	get_node("ExitButton").connect("pressed", self, "_on_exit_button_pressed")
	pass

func _on_reset_button_pressed():
	print("change scene")
	get_node("/root/global").goto_scene("res://src/game/gamescene.tscn")

func _on_exit_button_pressed():
	print("change scene")
	get_node("/root/global").goto_scene("res://src/menu/main_menu.tscn")


#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
