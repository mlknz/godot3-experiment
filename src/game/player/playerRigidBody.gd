extends RigidBody

var velocity = Vector3(0, 0, 0)
var g = 9.8

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _physics_process(delta):
	
	var spaceState = get_world().direct_space_state
	var objectPosition = translation
	var result = spaceState.intersect_ray(objectPosition, objectPosition + Vector3(0, -8, 0))
	var hitDist = -1;
	if result:
		hitDist = objectPosition.distance_to(result.position)
	
	# [0.0, 2.0]
	var acc = max((2.0 - hitDist), 0.0)
	acc = acc * delta * g
	apply_impulse(Vector3(0, 0, 0), Vector3(0, acc, 0))

	var controls = Vector3(0, 0, 0)
	if Input.is_action_pressed("ui_right"):
		controls.x = 10 * delta
	if Input.is_action_pressed("ui_left"):
		controls.x = -10 * delta
	if Input.is_action_pressed("ui_up"):
		controls.z = -10 * delta
	if Input.is_action_pressed("ui_down"):
		controls.z = 10 * delta
	#if Input.is_action_pressed("ui_accept"):
	
	apply_impulse(Vector3(0, 0, 0), controls)

func _integrate_forces(state):
	print(state.angular_velocity.x, " ", state.angular_velocity.y,
	" ", state.angular_velocity.z)
	#print(state.total_angular_damp)
	pass
