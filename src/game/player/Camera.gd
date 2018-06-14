extends Camera

var parent
var player
var prevMousePos = Vector2(-1, -1)
var phi
var theta
var r

var originPos

func _ready():
	parent = get_parent_spatial()
	player = parent.get_node("RigidBody")
	originPos = player.translation
	var tr = translation - originPos
	r = tr.length()
	phi = atan2(tr.x, tr.y)
	theta = acos(tr.z/r)
	pass

func _process(delta):	
	if Input.is_action_pressed("ui_mouse_left"):
		var v = get_viewport()
		var mousePos = v.get_mouse_position() / v.size
		if (prevMousePos.x > 0):
			var diff = mousePos - prevMousePos
			theta -= diff.y * 2
			phi -= diff.x * 2
		prevMousePos = mousePos
	else:
		prevMousePos.x = -1
	
	var targetPos = Vector3(player.translation.x, originPos.y, player.translation.z)
	translation = r * Vector3(cos(theta) * sin(phi), sin(theta) * sin(phi), cos(phi)) + targetPos
	var originWorld = player.global_transform.origin
	var lookAtPos = Vector3(originWorld.x, 1, originWorld.z)
	look_at(lookAtPos, Vector3(0, 1, 0))

