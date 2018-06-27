extends Camera

func _ready():
	translate(Vector3(0, 1.5, 3))
	look_at(Vector3(0, 0, -4), Vector3(0, 1, 0))
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
