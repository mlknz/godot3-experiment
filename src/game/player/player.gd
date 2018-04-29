extends Spatial

var playerMesh

func _ready():
	# Called every time the node is added to the scene.
	#playerMesh = get_node("PlayerMesh")
	pass

func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
	pass
	
func _physics_process(delta):
	if Input.is_action_pressed("ui_right"):
		translation.x += 1
	if Input.is_action_pressed("ui_left"):
		translation.x -= 1
	if Input.is_action_pressed("ui_up"):
		translation.z -= 1
	if Input.is_action_pressed("ui_down"):
		translation.z += 1
