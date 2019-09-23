class_name Item
extends RigidBody2D

enum Placement { UNDEFINED, INVENTORY, LEVEL, MERGER, DRAGDROP }

const ColorsPre = preload("res://autoload/Colors.gd")
export (ColorsPre.Palette) var _color = ColorsPre.Palette.WHITE

var color: Color
var level

var _placement setget _unsafely_set_placement
var initial_color


func _ready():
	var _initial_color = initial_color if initial_color else Colors.palette[_color]
	init(_initial_color, false, true, true, Placement.UNDEFINED)


func init(_color, is_visible, is_sleeping, collision_disabled, placement, with_tween = false, use_tween = null):
	visible = is_visible
	set_color(_color, with_tween, use_tween)
	initial_color = _color
	sleeping = is_sleeping
	set_collisions_disabled(collision_disabled)
	_placement = placement


func merge(items: Array, at_pos = null):
	var new_item = duplicate()
	if at_pos == null:
		at_pos = self.global_position
	
	new_item.global_position = at_pos
	new_item.initial_color = self.initial_color
	var all_items = items.duplicate(true)
	all_items.append(new_item)
	var new_color = Colors.merge_items(all_items)
	
	print(new_item.repr())
	
	for item in items:
		for sprite in item.get_sprites():
			var new_sprite = sprite.duplicate()
			new_item.add_child(new_sprite)
			new_sprite.global_position = sprite.global_position
			print("sprite global: ", sprite.global_position)
		for collision in item.get_collisions():
			var new_collision = collision.duplicate()
			new_item.add_child(new_collision)
			new_collision.global_position = collision.global_position
			print("collision global: ", collision.global_position)
	
	new_item.init(new_color, true, true, false, Placement.MERGER)
	
	print(new_item.repr())
	return new_item


func set_color(new_color: Color, with_tween = false, use_tween: Tween = null):
	color = new_color
	var sprites = get_sprites()
	if with_tween:
		Colors.tween_modulates(sprites, sprites[0].self_modulate, new_color, use_tween)
	else:
		set_sprites_modulate(new_color)


func restore_initial_color(with_tween = false, use_tween: Tween = null):
	set_color(initial_color, with_tween, use_tween)


func is_placed_at(placement):
	return _placement == placement


func set_placement_inventory():
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


func get_sprites():
	var sprites = []
	for child in get_children():
		if child is Sprite:
			sprites.append(child)
	return sprites


func set_sprites_modulate(_modulate: Color):
	for sprite in get_sprites():
		sprite.self_modulate = _modulate


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


func repr():
	var output = """
		%s (Ptr: %s) repr:
		------------------
		Position: %s  (Global: %s )
		Modulate: %s   (Self: %s)
		Children:\n""".dedent() % [name, self, position, 
		global_position, modulate, self_modulate]
	for child in get_children():
		output += ("""
		- Name: %s  (Ptr: %s)
		- Position: %s  (Global: %s )
		- Modulate: %s  (Self: %s)
		""" % [child.name, child, child.position, 
		child.global_position, child.modulate, 
		child.self_modulate]).dedent()
	output += "---------------\n%s repr END\n" % name
	return output


func _unsafely_set_placement(new_placement):
	print("Don't assign to placement directly",
		" use one of the set_placement_x methods")
