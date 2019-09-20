class_name Merger
extends Panel

signal closed(items)

export (bool) var close_on_click = false

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


func add_item(item: Item):
	if not is_active():
		return open(item)
	
	_items.append(item)


func open(item: Item):
	show()
	set_process_input(true)
	# Put item on center position, ready to MERG3
	
	item.set_placement_merger()
	drop_area.monitorable = true


func close() -> Array:
	hide()
	set_process_input(false)
	drop_area.monitorable = false
	return _items


func _on_Close_pressed():
	emit_signal("closed", close())


func _on_item_dropped(item, where, mouse_pos, mergeable_items):
	if where == DropArea.Kind.MERGER:
		print("merger received item ", item, where, mouse_pos, mergeable_items)
