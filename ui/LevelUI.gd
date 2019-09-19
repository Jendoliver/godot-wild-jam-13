class_name LevelUI
extends CanvasLayer

signal level_pause_changed(is_paused)

onready var inventory: ItemList = $Menu/Inventory
onready var merger = $Merger
onready var level_drop_area = $LevelDropArea

var _inventory = []


func _ready():
	DragDrop.connect("item_dropped", self, "_on_item_dropped")


func add_item_to_inventory(item: Item):
	_inventory.append(item)
	inventory.add_item('', item.sprite.texture, true)
	item.set_placement_inventory()


func remove_item_from_inventory(item: Item):
	_inventory.erase(item)
	inventory.remove_item(item.inventory_index)


func add_items_to_inventory(items: Array):
	for item in items:
		add_item_to_inventory(item)


func open_merger(with_item):
	level_drop_area.monitorable = false
	emit_signal("level_pause_changed", true)
	merger.open(with_item)


func _on_Merger_closed(items):
	level_drop_area.monitorable = true
	emit_signal("level_pause_changed", false)
	add_items_to_inventory(items)


func _on_item_dropped(item: Item, where, mouse_pos, mergeable_items):
	if where == DropArea.Kind.INVENTORY:
		add_item_to_inventory(item)


func _on_Inventory_item_click(idx):
	print(idx)
	# DETECT DRAG AND SEND TO DRAGDROP SOMEHOW
	pass


func _on_Inventory_item_double_click(idx):
	print(idx)
	var item = _inventory[idx]
	open_merger(item)
