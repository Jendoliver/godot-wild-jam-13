class_name LevelUI
extends Control

onready var inventory = $Menu/Inventory
onready var merger = $Merger
onready var _items = $Items  # REMOVE


# REMOVE
func _ready():
    add_items(_items.get_children())


func add_item(item: Item):
	item.sprite.hide()
	inventory.add_item('', item.sprite.texture, true)


func add_items(items: Array):
	for item in items:
		add_item(item)


func _on_Inventory_item_click(idx):
	pass


func _on_Inventory_item_double_click(idx):
	if not merger._active:
		merger.activate(inventory.get_item_at_position(idx))
