extends KinematicBody

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
	#velocity.y += - delta * g
	#applyImpulse(Vector3(0, 0, 0), Vector3(0, -delta * g, 0))
	
	#var collision = move_and_collide(velocity * delta)
	#if collision:
    #	velocity = velocity.slide(collision.normal
	velocity.x = 0;
	velocity.z = -0.1;
	
	var space_state = get_world().direct_space_state
	var result = space_state.intersect_ray(translation, translation + Vector3(0, -8, 0))
	var hitDist = -1;
	if result:
		hitDist = translation.distance_to(result.position)
	
	# [0.0, 2.0]
	var acc = (2.0 - hitDist) * delta * 2.0 * g
	#applyImpulse(Vector3(0, 0, 0), Vector3(0, acc, 0))
	#velocity.y += acc
	#print(velocity.y)
	
	if Input.is_action_pressed("ui_right"):
		velocity.x = 10
	if Input.is_action_pressed("ui_left"):
		velocity.x = -10
	if Input.is_action_pressed("ui_up"):
		velocity.z = -10
	if Input.is_action_pressed("ui_down"):
		velocity.z = 10
	#if Input.is_action_pressed("ui_accept"):
	
	# print(is_on_floor(), " ",is_on_wall())
	# move_and_collide(velocity * delta)
	velocity = move_and_slide(velocity, Vector3(0, 1, 0)) # todo: plane collision shape is broken
	
