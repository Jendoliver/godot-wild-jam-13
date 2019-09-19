class_name Item
extends RigidBody2D

enum Placement { UNDEFINED, INVENTORY, LEVEL, MERGER, DRAGDROP }

onready var sprite: Sprite = $Sprite
onready var collision: CollisionPolygon2D = $Collision

var _placement setget _unsafely_set_placement


func _ready():
	hide()
	sleeping = true
	_placement = Placement.UNDEFINED


func is_placed_at(placement):
	return _placement == placement


func set_placement_inventory():
	hide()
	sleeping = true
	_placement = Placement.INVENTORY


func set_placement_level():
	show()
	sleeping = false
	_placement = Placement.LEVEL


func set_placement_merger():
	show()
	sleeping = true
	_placement = Placement.MERGER


func set_placement_dragdrop():
	hide()
	sleeping = true
	_placement = Placement.DRAGDROP


func _unsafely_set_placement(new_placement):
	print("Don't assign to placement directly",
		" use one of the set_placement_x methods")
