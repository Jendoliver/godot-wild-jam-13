extends Node2D

signal item_dropped(item, where, mouse_pos, mergeable_items)

onready var detection_area: Area2D = $DetectionArea

var _dragged: Item
var _dragged_area: Area2D
var _dragged_sprites: Array
var _dragged_initial_color: Color  # TODO quitar cuando se mueva el item
var _area_over  # type DropArea.Kind
var _can_drop = false setget set_can_drop
var _mergeable_items = []
var _blocking_items = []


func _ready():
	_deactivate()


func _process(delta):
	global_position = get_global_mouse_position()


func _input(event):
	if event.is_action_released("primary"):
		try_drop()


func drag(item: Item):
	item.set_placement_dragdrop()
	_dragged = item
	
	_dragged_area = Area2D.new()
	add_child(_dragged_area)
	for sprite in item.get_sprites():
		var copy = sprite.duplicate()
		_dragged_sprites.append(copy)
		_dragged_area.add_child(copy)
		copy.show()
	_dragged_initial_color = _dragged.initial_color # TODO quitar cuando se mueva el item

	_dragged_area.monitorable = false
	for collision in item.get_collisions():
		var copy = collision.duplicate()
		_dragged_area.add_child(copy)
		copy.polygon = PoolVector2Array(collision.polygon)
		copy.disabled = false

	_dragged_area.connect("body_entered", self, "_on_dragged_overlap_start")
	_dragged_area.connect("body_exited", self, "_on_dragged_overlap_end")
	detection_area.connect("area_entered", self, "_on_detection_overlap_start")
	detection_area.connect("area_exited", self, "_on_detection_overlap_end")

	detection_area.monitoring = true
	set_process_input(true)
	_can_drop = true


func try_drop():
	if _can_drop:
		drop()
	else:
		drop(DropArea.Kind.INVENTORY)


func drop(_where = null):
	if _where == null:
		_where = _area_over
	
	var mouse_pos = get_global_mouse_position()
	emit_signal("item_dropped", 
		_dragged, _where, mouse_pos, _mergeable_items)
	print("item_dropped", 
		_dragged, _where, mouse_pos, _mergeable_items)
	_deactivate()


func _deactivate():
	detection_area.monitoring = false
	set_process_input(false)
	clear_dragged_area()
	_dragged = null
	_area_over = null
	_can_drop = false
	_mergeable_items.clear()
	_blocking_items.clear()


func clear_dragged_area():
	if not _dragged_area:
		return

	_dragged_area.queue_free()
	_dragged_sprites.clear()


func set_can_drop(can_drop):
	_can_drop = can_drop
	if _blocking_items.empty():
		pass  # Stop Tween
	else:
		pass  # Tween red to indicate that you can't drop
	


func is_currently_dragging() -> bool:
	return _dragged != null


func get_currently_dragged() -> Item:
	return _dragged


func add_blocking_item(item: Item):
	print("blocking item added: ", item.name)
	_blocking_items.append(item)
	set_can_drop(false)


func remove_blocking_item(item: Item):
	print("blocking item removed: ", item.name)
	_blocking_items.erase(item)
	if _blocking_items.empty():
		print("blocking items empty")
		set_can_drop(true)


func add_mergeable_item(item: Item):
	print("mergeable item added: ", item.name)
	_mergeable_items.append(item)
	tween_mergeables()


func remove_mergeable_item(item: Item):
	print("mergeable item removed: ", item.name)
	_mergeable_items.erase(item)
	tween_mergeables(item)


func tween_mergeables(removed_item = null):
	if removed_item != null:
		removed_item.restore_initial_color(true)
	
	var dragged_next_color = _dragged_initial_color
	if not _mergeable_items.empty():
		var colors = [_dragged_initial_color]
		for item in _mergeable_items:
			colors.append(item.color)
		var merged_color = Colors.merge(colors)
		if merged_color:
			dragged_next_color = merged_color
			for item in _mergeable_items:
				item.set_color(dragged_next_color, true)

	Colors.tween_modulates(_dragged_sprites, _dragged_sprites[0].self_modulate, dragged_next_color)


func _on_dragged_overlap_start(obj: PhysicsBody2D):
	print("_on_dragged_overlap_start", obj, obj.name)
	
	# Level geometry (not Items placed on level, but walls and shit)
	if obj is StaticBody2D:
		add_blocking_item(obj)
	
	elif obj is Item:
		if obj.is_placed_at(Item.Placement.MERGER):
			add_mergeable_item(obj)
		elif obj.is_placed_at(Item.Placement.LEVEL) and not obj.level.is_merger_open:
			add_blocking_item(obj)


func _on_dragged_overlap_end(obj: CollisionObject2D):
	if not detection_area.monitoring:
		return
	
	print("_on_dragged_overlap_end", obj, obj.name)
	if obj is StaticBody2D:
		remove_blocking_item(obj)
	
	elif obj is Item:
		if obj.is_placed_at(Item.Placement.MERGER):
			remove_mergeable_item(obj)
		elif obj.is_placed_at(Item.Placement.LEVEL) and not obj.level.is_merger_open:
			remove_blocking_item(obj)


func _on_detection_overlap_start(obj: DropArea):
	print("_on_detection_overlap_start", obj, obj.name)
	if obj:
		_area_over = obj.kind


func _on_detection_overlap_end(obj: DropArea):
	print("_on_detection_overlap_end", obj, obj.name)
	if obj:
		_area_over = null
