extends RigidBody

var gameOver = false

var velocity = Vector3(0, 0, 0)
var g = 9.8
var shapeExtents

var thrustSpots = []
var thrustOrientations = [] # unused
var thrustHitDistances = [0, 0, 0, 0]
var thrusterStrength = 3
var thrusterDist = 5

var forwardTouch = null;
var rotateTouch = null;
var moveUpTouch = null;
var moveDownTouch = null;
var forwardTouchDeltaX = 0;
var forwardTouchDeltaY = 0;
var rotateTouchDeltaX = 0;

func game_over():
	gameOver = true

func _ready():
	shapeExtents = get_node("CollisionShape").shape.extents
	var s = shapeExtents
	var y = -s.y + 0.05 # offset prevents stucking in floor
	thrustSpots = [Vector3(-s.x, y, s.z), Vector3(s.x, y, s.z), Vector3(-s.x, y, -s.z), Vector3(s.x, y, -s.z)]
	
	angular_damp = 0.7
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

	var rotateLeft = rotateTouchDeltaX * delta * mass * 0.02
	var forward = forwardTouchDeltaY * delta * mass * 0.1
	var leftStrafe = forwardTouchDeltaX * delta * mass * 0.04
	if moveUpTouch:
		thrusterStrength -= delta
	if moveDownTouch:
		thrusterStrength += delta

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
	
func _unhandled_input(event):
	if gameOver:
		return
	if event is InputEventScreenTouch:
		if event.is_pressed():
			var isRightHalf = event.get_position().x > get_viewport().get_visible_rect().size.x * 0.5
			var isUpperPart = event.get_position().y > get_viewport().get_visible_rect().size.y * 0.9
			var isDownPart = event.get_position().y < get_viewport().get_visible_rect().size.y * 0.1
			if !isRightHalf && isUpperPart:
				if !moveUpTouch:
					moveUpTouch = event
			elif !isRightHalf && isDownPart:
				if !moveDownTouch:
					moveDownTouch = event
			elif !forwardTouch && !isRightHalf:
				forwardTouch = event
				forwardTouchDeltaX = 0
				forwardTouchDeltaY = 0
			if !rotateTouch && isRightHalf:
				rotateTouch = event
				rotateTouchDeltaX = 0
		else:
			if forwardTouch && event.get_index() == forwardTouch.get_index():
				forwardTouch = null
				forwardTouchDeltaX = 0
				forwardTouchDeltaY = 0
			if rotateTouch && event.get_index() == rotateTouch.get_index():
				rotateTouch = null
				rotateTouchDeltaX = 0
			if moveUpTouch && event.get_index() == moveUpTouch.get_index():
				moveUpTouch = null
			if moveDownTouch && event.get_index() == moveDownTouch.get_index():
				moveDownTouch = null
	if event is InputEventScreenDrag:
		if forwardTouch && event.get_index() == forwardTouch.get_index():
			forwardTouchDeltaY = event.get_position().y - forwardTouch.get_position().y
			forwardTouchDeltaX = event.get_position().x - forwardTouch.get_position().x
		if rotateTouch && event.get_index() == rotateTouch.get_index():
			rotateTouchDeltaX = - event.get_position().x + rotateTouch.get_position().x