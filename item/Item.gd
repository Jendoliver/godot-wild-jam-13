class_name Item
extends RigidBody2D

enum Placement { UNDEFINED, INVENTORY, LEVEL, MERGER, DRAGDROP }

export (preload("res://autoload/Colors.gd").Palette) var _color

onready var sprite: Sprite = $Sprite

var color: Color
var level

var _placement setget _unsafely_set_placement
var _initial_color


func _ready():
	init(Colors.palette[_color], false, true, true, Placement.UNDEFINED)


func init(_color, is_visible, is_sleeping, collision_disabled, placement, tween_color = false):
	visible = is_visible
	if tween_color:
		set_color(_color, tween_color)
	else:
		color = _color
	_initial_color = _color
	sleeping = is_sleeping
	set_collisions_disabled(collision_disabled)
	_placement = placement


func merge(items: Array, inplace = false):
	var _new_item = self
	if not inplace:
		_new_item = load("res://item/Item.tscn").instance()
	
	var _items = items.duplicate()
	_items.append(self)
	var new_color = Colors.merge_items(_items)
	_new_item.init(new_color, true, true, false, Placement.MERGER)
	
	return _new_item


func set_color(new_color: Color, tween: Tween = null):
	color = new_color
	Colors.tween_sprite(sprite, sprite.modulate, new_color, tween)


func restore_initial_color():
	set_color(_initial_color)


func is_placed_at(placement):
	return _placement == placement


func set_placement_inventory():
	#hide()
	show()
	sleeping = true
	gravity_scale = 0
	set_collisions_disabled(true)
	_placement = Placement.INVENTORY


func set_placement_level():
	show()
	sleeping = false
	gravity_scale = 1
	set_collisions_disabled(false)
	_placement = Placement.LEVEL


func set_placement_merger():
	show()
	sleeping = true
	gravity_scale = 0
	set_collisions_disabled(false)
	_placement = Placement.MERGER


func set_placement_dragdrop():
	hide()
	sleeping = true
	gravity_scale = 0
	set_collisions_disabled(true)
	_placement = Placement.DRAGDROP


func get_collisions():
	var collisions = []
	for child in get_children():
		if child is CollisionPolygon2D or child is CollisionShape2D:
			collisions.append(child)
	return collisions


func set_collisions_disabled(_disabled):
	for child in get_children():
		if child is CollisionPolygon2D or child is CollisionShape2D:
			child.disabled = _disabled


func _unsafely_set_placement(new_placement):
	print("Don't assign to placement directly",
		" use one of the set_placement_x methods")
