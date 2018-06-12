extends Camera

var parent
var prevMousePos = Vector2(-1, -1)
var phi
var theta
var r

func _ready():
	parent = get_parent_spatial()
	r = translation.length()
	phi = atan2(translation.x, translation.y)
	theta = acos(translation.z/r)
	pass

func _process(delta):
	if Input.is_action_pressed("ui_mouse_left"):
		var v = get_viewport()
		var mousePos = v.get_mouse_position() / v.size
		if (prevMousePos.x > 0):
			var diff = mousePos - prevMousePos
			theta -= diff.y * 2
			phi -= diff.x * 2
			translation = r * Vector3(cos(theta) * sin(phi), sin(theta) * sin(phi), cos(phi))
			look_at(parent.global_transform.origin, Vector3(0, 1, 0))
		prevMousePos = mousePos
	else:
		prevMousePos.x = -1

