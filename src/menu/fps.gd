extends Label

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export (PackedScene) var Game

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	#get_node("Panel/Button").connect("pressed", self, "_on_button_pressed")
	#get_tree().change_scene("res://levels/level2.tscn")
	pass
	
var accum = 0

#func _on_button_pressed():
	#var game = Game.instance()
	#add_child(game)
	#get_node("Panel").queue_free()
	
func _process(delta):
	accum += delta
	text = str(accum)
	
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
	pass

func _physics_process(delta):
    # This is called every physics frame.
    pass