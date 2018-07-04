extends Spatial

var isDebug = OS.is_debug_build()
var player
var camera

func _ready():
	_add_player()
	_add_env("res://assets/levels/level.json")
	_add_gui()

func _add_player():
	player = ResourceLoader.load("res://src/game/player/player.tscn").instance()
	add_child(player)
	
	var playerDebugInfo = Spatial.new()
	playerDebugInfo.set_script(
			ResourceLoader.load("res://src/game/player/debug/physicsDebugInfo.gd"))
	#if isDebug:
	#	player.add_child(playerDebugInfo)
	
	camera = Camera.new()
	add_child(camera)

func _add_env(levelName):
	var file = File.new()
	file.open(levelName, file.READ)
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
	
	var finishArea = ResourceLoader.load("res://src/game/env/FinishArea.tscn").instance()
	finishArea.translate(Vector3(-5, 0, -5))
	finishArea.connect("body_entered", self, "_on_finish_area_body_entered")
	add_child(finishArea)
	
	var damageArea = ResourceLoader.load("res://src/game/env/DamageArea.tscn").instance()
	damageArea.translate(Vector3(-2, 0, -7))
	damageArea.connect("body_entered", self, "_on_damage_area_body_entered")
	add_child(damageArea)

func _add_gui():
	get_node("ResetButton").connect("pressed", self, "_on_reset_button_pressed")
	get_node("ExitButton").connect("pressed", self, "_on_exit_button_pressed")

func _on_finish_area_body_entered(body):
	if body.get_instance_id() == player.get_instance_id():
		_show_result_popup(true)
	
func _on_damage_area_body_entered(body):
	if body.get_instance_id() == player.get_instance_id():
		_show_result_popup(false)

func _show_result_popup(isWin):
	var popup = ResourceLoader.load("res://src/menu/popups/GameResult.tscn").instance()
	add_child(popup)
	popup.popup_centered()
	var title = popup.get_node("TitleLabel")
	title.set_text("You win" if isWin else "Game over")
	
func _on_reset_button_pressed():
	print("change scene")
	get_node("/root/global").goto_scene("res://src/game/gamescene.tscn")

func _on_exit_button_pressed():
	print("change scene")
	get_node("/root/global").goto_scene("res://src/menu/main_menu.tscn")

func _process(delta):
	var playerPos = player.global_transform.origin
	var z = player.global_transform.basis.z
	z.y = 0
	
	camera.translation = playerPos + Vector3(0, 2, 0) + z * 4
	camera.look_at(playerPos - z * 5, Vector3(0, 1, 0))
	pass
