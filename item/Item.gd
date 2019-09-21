class_name Item
extends RigidBody2D

enum Placement { UNDEFINED, INVENTORY, LEVEL, MERGER, DRAGDROP }

# Keep on pair with Colors.gd
export (String, \
	"red", "green", "blue", "yellow", \
	"magenta", "cyan", "white", "black") var color = "white"

onready var sprite: Sprite = $Sprite
onready var collision: CollisionPolygon2D = $Collision

var _placement setget _unsafely_set_placement


func _ready():
	hide()
	set_color(Colors.palette[color])
	sleeping = true
	collision.disabled = true
	_placement = Placement.UNDEFINED


func get_color() -> Color:
	return sprite.modulate


func set_color(_color: Color):
	sprite.modulate = _color


func is_placed_at(placement):
	return _placement == placement


func set_placement_inventory():
	#hide()
	show()
	sleeping = true
	gravity_scale = 0
	collision.disabled = true
	_placement = Placement.INVENTORY


func set_placement_level():
	show()
	sleeping = false
	gravity_scale = 1
	collision.disabled = false
	_placement = Placement.LEVEL


func set_placement_merger():
	show()
	sleeping = true
	gravity_scale = 0
	collision.disabled = false
	_placement = Placement.MERGER


func set_placement_dragdrop():
	hide()
	sleeping = true
	gravity_scale = 0
	collision.disabled = true
	_placement = Placement.DRAGDROP


func _unsafely_set_placement(new_placement):
	print("Don't assign to placement directly",
		" use one of the set_placement_x methods")
