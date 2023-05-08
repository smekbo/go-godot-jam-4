extends Node3D

@onready var active = $active
@onready var pool = $pool

@onready var special_segments = [
	{"rng" : 0.05, "scene" : preload("res://floor_segments/floor_segment_wall.tscn")},
	{"rng" : 0.1, "scene" : preload("res://floor_segments/floor_segment_hole.tscn")}
]
@onready var plain_segment = preload("res://floor_segments/floor_segment.tscn")

@export var NUMBER_OF_SEGMENTS : int = 100
@export var NUMBER_OF_ACTIVE_SEGMENTS : int = 30
@export var SPEED : float

var rng = RandomNumberGenerator.new()

var GENERATED_SEGMENTS : Array


func _ready():
	generateSegmentPool()
	createStartingTrack()
	

func _process(delta):
	for segment in active.get_children():
		segment as FloorSegment
		segment.path.progress -= SPEED * delta
		if segment.path.progress <= segment.getConnectionPoint():
			var farthestSegment = getFarthestSegment()
			var newSegment = substitueFloorSegment(segment)
			newSegment.path.progress = farthestSegment.path.progress + farthestSegment.getConnectionPoint() -3.5
			pass

func generateSegmentPool():
	for i in NUMBER_OF_SEGMENTS:
		var segment : FloorSegment = generateFloorSegment()
		pool.add_child(segment)


func createStartingTrack():
	for i in NUMBER_OF_ACTIVE_SEGMENTS:
		var segment : FloorSegment = pool.get_child(0)
		pool.remove_child(segment)
		active.add_child(segment)
		var farthestSegment = getFarthestSegment()
		segment.path.progress = farthestSegment.path.progress + farthestSegment.getConnectionPoint()


func substitueFloorSegment(segment : FloorSegment):
	active.remove_child(segment)
	pool.add_child(segment)
	var sub = pool.get_child(rng.randi_range(0,pool.get_child_count()-1))
	pool.remove_child(sub)
	active.add_child(sub)
	return sub


func generateFloorSegment() -> FloorSegment:
	for segment in special_segments:
		var floorRng = rng.randf()
		if segment.rng > floorRng:
			return segment.scene.instantiate()
	return plain_segment.instantiate()


func getFarthestSegment() -> FloorSegment:
	var farthest = active.get_child(0)
	for segment in active.get_children():
		if segment.path.progress > farthest.path.progress:
			farthest = segment
	return farthest as FloorSegment
