extends Node2D

signal item_dropped(item, where, mouse_pos, mergeable_items)

onready var detection_area: Area2D = $DetectionArea

var _dragged: Item
var _dragged_sprite: Sprite
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
	
	_dragged_sprite = item.sprite.duplicate()
	_dragged_sprite.show()
	_dragged_sprite.modulate.a = 150
	_dragged_sprite.z_index = 10
	
	var dragged_area = Area2D.new()
	dragged_area.monitorable = false
	var dragged_area_collision = item.collision.duplicate()
	dragged_area_collision.disabled = false
	
	dragged_area.add_child(dragged_area_collision)
	_dragged_sprite.add_child(dragged_area)
	add_child(_dragged_sprite)
	dragged_area.connect("body_entered", self, "_on_dragged_overlap_start")
	dragged_area.connect("body_exited", self, "_on_dragged_overlap_end")
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
	clear_dragged_sprite()
	_dragged = null
	_dragged_sprite = null
	_area_over = null
	_can_drop = false
	_mergeable_items.clear()
	_blocking_items.clear()


func clear_dragged_sprite():
	if not _dragged_sprite:
		return

	_dragged_sprite.get_child(0).get_child(0).queue_free()
	_dragged_sprite.get_child(0).queue_free()
	_dragged_sprite.queue_free()


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
	_blocking_items.append(item)
	set_can_drop(false)


func remove_blocking_item(item: Item):
	_blocking_items.erase(item)
	if _blocking_items.empty():
		set_can_drop(true)


func update_tween_modulate_with_mergeables():
	if _mergeable_items.empty():
		pass  # Stop Tween
	else:
		pass  # Tween mergeables modulate into the new color


func _on_dragged_overlap_start(obj: PhysicsBody2D):
	print("_on_overlap_start", obj, obj.name)
	
	# Level geometry (not Items placed on level, but walls and shit)
	if obj is StaticBody2D:
		add_blocking_item(obj)
	
	elif obj is Item:
		if obj.is_placed_at(Item.Placement.MERGER):
			_mergeable_items.append(obj)
			update_tween_modulate_with_mergeables()
		elif obj.is_placed_at(Item.Placement.LEVEL):
			add_blocking_item(obj)


func _on_dragged_overlap_end(obj: CollisionObject2D):
	print("_on_overlap_end", obj, obj.name)
	
	if obj is StaticBody2D:
		remove_blocking_item(obj)
	
	elif obj is Item:
		if obj.is_placed_at(Item.Placement.MERGER):
			_mergeable_items.erase(obj)
			update_tween_modulate_with_mergeables()
		elif obj.is_placed_at(Item.Placement.LEVEL):
			remove_blocking_item(obj)


func _on_detection_overlap_start(obj: DropArea):
	print("_on_detection_overlap_start", obj, obj.name)
	if obj:
		_area_over = obj.kind


func _on_detection_overlap_end(obj: DropArea):
	print("_on_detection_overlap_end", obj, obj.name)
	if obj:
		_area_over = null
