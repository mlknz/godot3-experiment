extends Spatial

var playerBody
var isDebug = OS.is_debug_build()

# todo: move to separate module
var debugRaycastSphereSize = 0.2
var debugSpheres = []
var debugSticks = []

func _ready():
	playerBody = get_node("RigidBody")
	
	if (isDebug && playerBody):
		for i in range(playerBody.thrustSpots.size()):
			debugSpheres.append(MeshInstance.new())
			debugSpheres[i].mesh = SphereMesh.new()
			debugSpheres[i].mesh.radius = debugRaycastSphereSize
			debugSpheres[i].mesh.height = debugRaycastSphereSize * 2.0
			#playerBody.add_child(debugSpheres[i])
		
			debugSticks.append(MeshInstance.new())
			debugSticks[i].mesh = CylinderMesh.new()
			debugSticks[i].mesh.bottom_radius = debugRaycastSphereSize * 0.1
			debugSticks[i].mesh.top_radius = debugRaycastSphereSize * 0.1
			#playerBody.add_child(debugSticks[i])
	

func _process(delta):
	if (isDebug && playerBody):
		for i in range(debugSpheres.size()):
			debugSpheres[i].translation = playerBody.thrustSpots[i] + Vector3(0, -playerBody.thrustHitDistances[i], 0)
			debugSticks[i].mesh.height = playerBody.thrustHitDistances[i]
			debugSticks[i].translation = playerBody.thrustSpots[i] + Vector3(0, -playerBody.thrustHitDistances[i] *0.5, 0)
	pass

func _physics_process(delta):
	