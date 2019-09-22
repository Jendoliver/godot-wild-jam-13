class_name Merger
extends Panel

signal closed(items)
signal merged(new_item)

onready var drop_area: DropArea = $DropArea
onready var first_pos: Position2D = $FirstPos

var active setget , is_active
var _items = []


func _ready():
	hide()
	set_process_input(false)
	drop_area.monitorable = false
	DragDrop.connect("item_dropped", self, "_on_item_dropped")


func _input(event):
	if not event is InputEventMouse:
		return
	
	# Handle shit (drags, drops, clicks, etc)

func is_active():
	return drop_area.monitorable


func open(item: Item):
	if is_active():
		_close()  # Close and reopen
	
	show()
	set_process_input(true)
	item.global_position = first_pos.global_position
	drop_area.monitorable = true
	_add_item(item)


func _merge(item, with_items, new_item_pos):
	for old_item in with_items:
		old_item.queue_free()
		_items.erase(old_item)
	var new_item = item.merge(with_items)
	_add_item(new_item, new_item_pos)
	emit_signal("merged", new_item)
	print("merge called with " + item.name + " and " + str(with_items))


func _add_item(item: Item, at_pos = null):
	if at_pos != null:
		item.global_position = at_pos
	
	_items.append(item)
	item.set_placement_merger()


func _close():
	hide()
	set_process_input(false)
	drop_area.monitorable = false
	var _returned_items = _items.duplicate()
	_items.clear()
	emit_signal("closed", _returned_items)


func _on_item_dropped(item, where, mouse_pos, mergeable_items):
	if where == DropArea.Kind.MERGER:
		if mergeable_items.empty():
			_add_item(item, mouse_pos)
		else:
			_merge(item, mergeable_items, mouse_pos)
