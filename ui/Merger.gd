class_name Merger
extends Panel

signal closed

export (bool) var close_on_click = false

var _active = false
var _items = []


func _ready():
	hide()
	set_process_input(false)
	DragDrop.connect("drop", self, "_on_item_drop")
	_active = false


func _input(event):
	if not event is InputEventMouse:
		return
	
	# Handle shit (drags, drops, clicks, etc)


func open(item: Item):
	show()
	set_process_input(true)
	# Put item on center position, ready to MERG3
	
	_active = true  # Keep last


func close():
	hide()
	set_process_input(false)
	_active = false  # Keep last


func close_get_items() -> Array:
	close()
	return _items


func _on_item_drop(item: Item):
	# Check if item is in area
	pass


func _on_Close_pressed():
	close() if close_on_click else emit_signal("closed")
