class_name Inventory
extends GridContainer

signal item_clicky(item)
signal item_double_clicky(item)

onready var timer = $Timer

var items = Array()
var is_double_clicky_posible = false

func _ready():
	pass
	#hseparation = 900
	

func _gui_input(event):
	if event is InputEventMouseButton:
		print("mouse: " +str(get_global_mouse_position()))
		if event.is_action_pressed("primary"):
			for item in items:
				var item_relative_mouse_pos = item.get_local_mouse_position()
				#unreliable if we merge two sprites
				var is_clicked = item_relative_mouse_pos.x >= 0 && item_relative_mouse_pos.x <= item.get_child(0).texture.get_width() && item_relative_mouse_pos.y >= 0 && item_relative_mouse_pos.y <= item.get_child(0).texture.get_height()
				if is_clicked && not is_double_clicky_posible:
					is_double_clicky_posible = true
					timer.start()
					emit_signal("item_clicky",item)
					break
				if is_clicked && is_double_clicky_posible:
					_disable_doubleclick()
					emit_signal("item_double_clicky",item)
					break

func add_item(item: Item):
	item.get_node("..").remove_child(item)
	var control = Control.new()
	control.set_h_size_flags(SIZE_EXPAND) #Item expands to fill al available space
	# SIZE_SHRINK_CENTER Item centered
	control.add_child(item)
	add_child(control)
	items.append(item)
	item.set_placement_inventory()
	print(item.is_visible_in_tree())

func remove_item(item: Item):
	remove_child(item)
	var index = items.find(item)
	items.remove(index)
	item.set_placement_dragdrop()

func _disable_doubleclick():
	is_double_clicky_posible = false

func _on_Timer_timeout():
	_disable_doubleclick()
