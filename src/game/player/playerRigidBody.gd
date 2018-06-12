extends RigidBody

var velocity = Vector3(0, 0, 0)
var g = 9.8

var thrustSpots = []
var thrustOrientations = [] # unused
var thrustHitDistances = [0, 0, 0, 0]

func _ready():
	var s = get_node("CollisionShape").shape.extents
	thrustSpots = [Vector3(-s.x, 0, s.z), Vector3(s.x, 0, s.z), Vector3(-s.x, 0, -s.z), Vector3(s.x, 0, -s.z)]
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _physics_process(delta):
	var spaceState = get_world().direct_space_state

	for i in range(thrustSpots.size()):
		var tr = translation + thrustSpots[i]
		var result = spaceState.intersect_ray(tr, tr - 8 * global_transform.basis.y, [self], collision_mask)
		thrustHitDistances[i] = translation.distance_to(result.position) if result else 0
		
		# draft broken logic
		var acc = max((0.5 - thrustHitDistances[i]), 0.0)
		acc = acc * delta * g
		apply_impulse(thrustSpots[i], acc * global_transform.basis.y)

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
	#print(state.angular_velocity.x, " ", state.angular_velocity.y,
	#" ", state.angular_velocity.z)
	#print(state.total_angular_damp)
	pass
