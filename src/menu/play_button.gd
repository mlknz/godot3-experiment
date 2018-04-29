extends Panel


func _ready():
	# Called every time the node is added to the scene.
	get_node("PlayButton").connect("pressed", self, "_on_button_pressed")
	pass
	
func _on_button_pressed():
	print("change scene")
	get_node("/root/global").goto_scene("res://src/game/gamescene.tscn")

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
