extends RigidBody

var velocity = Vector3(0, 0, 0)
var g = 9.8

var thrustSpots = []
var thrustOrientations = [] # unused
var thrustHitDistances = [0, 0, 0, 0]
var thrusterStrength = 3
var thrusterDist = 5

func _ready():
	var s = get_node("CollisionShape").shape.extents
	var y = -s.y + 0.05 # offset prevents stucking in floor
	thrustSpots = [Vector3(-s.x, y, s.z), Vector3(s.x, y, s.z), Vector3(-s.x, y, -s.z), Vector3(s.x, y, -s.z)]
	
	angular_damp = 0.7 # seems we need custom damp
	pass

#func _process(delta):
#	pass

func _physics_process(delta):
	var spaceState = get_world().direct_space_state
	var up = global_transform.basis.y.normalized()
	
	for i in range(thrustSpots.size()):
		var tr = global_transform.origin + thrustSpots[i]
		var result = spaceState.intersect_ray(tr, tr - thrusterDist * up)
		thrustHitDistances[i] = tr.distance_to(result.position) if result else thrusterDist
		print(thrustHitDistances[i])
		var acc = 1.0 - min(thrustHitDistances[i] / thrusterDist, 1.0)

		acc = pow(acc, 1) * delta * thrusterStrength * mass
		apply_impulse(thrustSpots[i], acc * up)

	var controls = Vector3(0, 0, 0)
	if Input.is_action_pressed("ui_right"):
		controls.x = 5 * delta * mass
	if Input.is_action_pressed("ui_left"):
		controls.x = -5 * delta * mass
	if Input.is_action_pressed("ui_up"):
		controls.z = -5 * delta * mass
	if Input.is_action_pressed("ui_down"):
		controls.z = 5 * delta * mass
	#if Input.is_action_pressed("ui_accept"):
	
	apply_impulse(Vector3(0, 0, 0), global_transform.basis.z * controls.z)
	apply_impulse(Vector3(0, 0, 0), global_transform.basis.x * controls.x)

func _integrate_forces(state):
	#print(state.angular_velocity.x, " ", state.angular_velocity.y,
	#" ", state.angular_velocity.z)
	#print(state.total_angular_damp)
	pass
