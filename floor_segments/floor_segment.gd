extends PathFollow3D
class_name FloorSegment

@onready var connecting_point = $connecting_point
@onready var path : PathFollow3D = self

func getConnectionPoint():
	return connecting_point.position.z
