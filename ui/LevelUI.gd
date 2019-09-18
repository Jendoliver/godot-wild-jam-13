class_name LevelUI
extends Control

signal item_dropped(item)

onready var inventory: ItemList = $Menu/Inventory
onready var merger = $Merger
onready var _items = $Items  # REMOVE

var _inventory = []
var _dragdrop_in_main_area = false
var _dragdrop_in_inventory_area = false


# REMOVE
func _ready():
	add_items(_items.get_children())
	DragDrop.connect("drop", self, "_on_item_drop")


func add_item(item: Item):
	item.sprite.hide()
	var index = _inventory.size()
	_inventory.append(item)
	item.inventory_index = index
	inventory.add_item('', item.sprite.texture, true)

func remove_item(item: Item):
	_inventory.erase(item)
	inventory.remove_item(item.inventory_index)
	if not merger._active: # Keeping index to put the item on the same position when merger closes
		item.inventory_index = -1
	item.sprite.show()	


func add_items(items: Array):
	for item in items:
		add_item(item)


func _on_item_drop(item: Item):
	# Check where DragDrop is, send item to Inventory/Merger/Level
	if _dragdrop_in_inventory_area :
		# Inventory
		add_item(item)
	elif _dragdrop_in_main_area :
		# Merger / Level
		if merger._active :
			remove_item(item)
			merger.add_item(item)
		else : emit_signal("item_dropped",item)
	else : print("where u dropin at m8?")


func _on_Inventory_item_click(idx):
	print(idx)
	pass


func _on_Inventory_item_double_click(idx):
	print(idx)
	if not merger._active:
		merger.activate(inventory.get_item_at_position(idx))


func _on_InventoryDropArea_area_entered(area: Area2D):
	if area is DragDropArea:
		_dragdrop_in_inventory_area = true


func _on_InventoryDropArea_area_exited(area: Area2D):
	if area is DragDropArea:
		_dragdrop_in_inventory_area = false


func _on_MainDropArea_area_entered(area: Area2D):
	if area is DragDropArea:
		_dragdrop_in_main_area = true


func _on_MainDropArea_area_exited(area: Area2D):
	if area is DragDropArea:
		_dragdrop_in_main_area = false
