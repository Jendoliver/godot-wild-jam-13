extends Node2D

signal item_dropped(item, where, mouse_pos, mergeable_items)

var _dragged: Item
var _dragged_sprite: Sprite
var _area_over  # type DropArea.Kind
var _drop_blockers = []
var _mergeable_items = []


func _ready():
	set_process(false)


func _process(delta):
	_dragged_sprite.global_position = get_global_mouse_position()
	if Input.is_action_just_released("interact"):
		try_drop()


func drag(item: Item):
	_drop_blockers.clear()
	item.set_placement_dragdrop()
	_dragged = item
	
	_dragged_sprite = Sprite.new()
	_dragged_sprite.texture = item.sprite.texture.duplicate()
	_dragged_sprite.modulate.a = 150
	_dragged_sprite.z_index = 1000
	
	var dragdrop_area = Area2D.new()
	var dragdrop_area_collision = item.collision.duplicate()
	dragdrop_area_collision.disabled = false
	
	dragdrop_area.add_child(dragdrop_area_collision)
	_dragged_sprite.add_child(dragdrop_area)
	add_child(_dragged_sprite)
	dragdrop_area.connect("area_entered", self, "_on_overlap_start")
	dragdrop_area.connect("body_entered", self, "_on_overlap_start")
	dragdrop_area.connect("area_exited", self, "_on_overlap_end")
	dragdrop_area.connect("body_exited", self, "_on_overlap_end")

	set_process(true)


func try_drop():
	if can_drop():
		drop()
	else:
		drop(DropArea.Kind.INVENTORY)


func can_drop():
	return _drop_blockers.empty()


func drop(_where = null):
	if _where == null:
		_where = _area_over
	
	_dragged_sprite.get_child(0).get_child(0).queue_free()
	_dragged_sprite.get_child(0).queue_free()
	_dragged_sprite.queue_free()
	var mouse_pos = get_global_mouse_position()
	emit_signal("item_dropped", _dragged, _where, mouse_pos, _mergeable_items)
	print("item_dropped")
	set_process(false)


func is_currently_dragging() -> bool:
	return _dragged != null


func get_currently_dragged() -> Item:
	return _dragged


func _on_overlap_start(obj: CollisionObject2D):
	print("_on_overlap_start", obj, obj.name)
	
	# Level geometry (not Items placed on level, but walls and shit)
	if obj is StaticBody2D:
		_drop_blockers.append(obj)
	
	elif obj is DropArea:
		_area_over = obj.kind
	
	elif obj is Item:
		if obj.is_placed_at(Item.Placement.MERGER):
			# START parpadeus of items, Tween
			_mergeable_items.append(obj)
		elif obj.is_placed_at(Item.Placement.LEVEL):
			_drop_blockers.append(obj)


func _on_overlap_end(obj: CollisionObject2D):
	print("_on_overlap_end", obj, obj.name)
	
	if obj is StaticBody2D:
		_drop_blockers.erase(obj)
	
	elif obj is DropArea:
		_area_over = null
	
	elif obj is Item:
		if obj.is_placed_at(Item.Placement.MERGER):
			# STOP parpadeus of items, Tween
			_mergeable_items.erase(obj)
		elif obj.is_placed_at(Item.Placement.LEVEL):
			_drop_blockers.erase(obj)
