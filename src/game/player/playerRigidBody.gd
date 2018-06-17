extends RigidBody

var velocity = Vector3(0, 0, 0)
var g = 9.8
var shapeExtents

var thrustSpots = []
var thrustOrientations = [] # unused
var thrustHitDistances = [0, 0, 0, 0]
var thrusterStrength = 3
var thrusterDist = 5

func _ready():
	shapeExtents = get_node("CollisionShape").shape.extents
	var s = shapeExtents
	var y = -s.y + 0.05 # offset prevents stucking in floor
	thrustSpots = [Vector3(-s.x, y, s.z), Vector3(s.x, y, s.z), Vector3(-s.x, y, -s.z), Vector3(s.x, y, -s.z)]
	
	angular_damp = 0.7 # probably we need custom damp
	linear_damp = 0.7
	pass

#func _process(delta):
#	pass

func _physics_process(delta):
	var spaceState = get_world().direct_space_state
	var up = global_transform.basis.y.normalized()
	
	var currentVelocity = linear_velocity # use for impulse correction
	
	for i in range(thrustSpots.size()):
		var tr = to_global(thrustSpots[i])
		var result = spaceState.intersect_ray(tr, tr - thrusterDist * up)
		thrustHitDistances[i] = tr.distance_to(result.position) if result else thrusterDist
		var acc = 1.0 - min(thrustHitDistances[i] / thrusterDist, 1.0)

		acc = pow(acc, 1) * delta * thrusterStrength * mass
		apply_impulse(tr - global_transform.origin, acc * up) # find howto localTransform * Vec3 here :(

	var rotateLeft = 0
	var forward = 0
	var leftStrafe = 0
	if Input.is_action_pressed("ui_right"):
		rotateLeft = - 0.8 * delta * mass
	if Input.is_action_pressed("ui_left"):
		rotateLeft = 0.8 * delta * mass
	if Input.is_action_pressed("ui_up"):
		forward = -5 * delta * mass
	if Input.is_action_pressed("ui_down"):
		forward = 5 * delta * mass
	if Input.is_action_pressed("Key_A"):
		leftStrafe = -5 * delta * mass
	if Input.is_action_pressed("Key_D"):
		leftStrafe = 5 * delta * mass
	if Input.is_action_pressed("Key_W"):
		thrusterStrength += delta
	if Input.is_action_pressed("Key_S"):
		thrusterStrength -= delta
	
	apply_impulse(Vector3(0, 0, 0), global_transform.basis.z * forward)
	apply_impulse(Vector3(0, 0, 0), global_transform.basis.x * leftStrafe)
	var pitchTorqueSpot = global_transform.basis.z.normalized() * shapeExtents.z
	apply_impulse(pitchTorqueSpot, global_transform.basis.x * rotateLeft)

func _integrate_forces(state):
	#print(state.angular_velocity.x, " ", state.angular_velocity.y,
	#" ", state.angular_velocity.z)
	#print(state.total_angular_damp)
	pass
