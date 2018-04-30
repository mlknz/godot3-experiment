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
	velocity.y += - delta * g
	
	#var collision = move_and_collide(velocity * delta)
	#if collision:
    #	velocity = velocity.slide(collision.normal
	velocity.x = 0;
	velocity.z = 0;
	if Input.is_action_pressed("ui_right"):
		velocity.x = 10
	if Input.is_action_pressed("ui_left"):
		velocity.x = -10
	if Input.is_action_pressed("ui_up"):
		velocity.z = -10
	if Input.is_action_pressed("ui_down"):
		velocity.z = 10
	if Input.is_action_pressed("ui_accept"):
		velocity.y += delta * 2.0 * g
	# print(is_on_floor(), " ",is_on_wall())
	# move_and_collide(velocity * delta)
	velocity = move_and_slide(velocity, Vector3(0, 1, 0)) # todo: plane collision shape is broken
