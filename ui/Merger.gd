class_name Merger
extends Panel

signal closed(items)

export (bool) var close_on_click = false

onready var drop_area = $DropArea

var _active = false
var _items = []


func _ready():
	hide()
	set_process_input(false)
	_active = false
	DragDrop.connect


func _input(event):
	if not event is InputEventMouse:
		return
	
	# Handle shit (drags, drops, clicks, etc)

func add_item(item: Item):
	if not _active:
		return open(item)
	
	_items.append(item)


func open(item: Item):
	show()
	set_process_input(true)
	# Put item on center position, ready to MERG3
	
	item.set_placement_merger()
	_active = true  # Keep last


func close() -> Array:
	hide()
	set_process_input(false)
	_active = false
	return _items


func _on_Close_pressed():
	emit_signal("closed", close())
