class_name LevelUI
extends CanvasLayer

signal merger_state_changed(is_active)

export (int) var min_drag_distance = 10

onready var inventory: ItemList = $Menu/Inventory
onready var merger = $Merger
onready var level_drop_area = $LevelDropArea
onready var level = get_node('..')  # Bad practice pero vamos apuradetes

var _inventory = []
var _possible_dragged_item_idx
var _possible_drag_start_pos


func _ready():
	DragDrop.connect("item_dropped", self, "_on_item_dropped")


func _input(event):
	if event is InputEventMouseButton:
		if event.is_action_released("primary"):
			_possible_dragged_item_idx = null
			_possible_drag_start_pos = null
			return

	if not (event is InputEventMouseMotion
	and _possible_dragged_item_idx != null
	and _possible_drag_start_pos != null):
		return

	var current_mouse_pos = level.get_global_mouse_position()
	var drag_distance = current_mouse_pos.distance_to(_possible_drag_start_pos)
	if drag_distance > min_drag_distance:
		var item = _inventory[_possible_dragged_item_idx]
		DragDrop.drag(item)
		remove_item_from_inventory(_possible_dragged_item_idx)
		_possible_dragged_item_idx = null
		_possible_drag_start_pos = null


func add_item_to_inventory(item: Item):
	_inventory.append(item)
	inventory.add_item('', item.sprite.texture, true)
	item.set_placement_inventory()


func remove_item_from_inventory(item_idx):
	_inventory.remove(item_idx)
	inventory.remove_item(item_idx)


func add_items_to_inventory(items: Array):
	for item in items:
		add_item_to_inventory(item)


func open_merger(with_item):
	level_drop_area.monitorable = false
	emit_signal("merger_state_changed", true)
	merger.open(with_item)


func _on_Merger_closed(items):
	level_drop_area.monitorable = true
	emit_signal("merger_state_changed", false)
	add_items_to_inventory(items)


func _on_item_dropped(item: Item, where, mouse_pos, mergeable_items):
	if where == DropArea.Kind.INVENTORY:
		add_item_to_inventory(item)


func _on_Inventory_item_click(idx):
	_possible_dragged_item_idx = idx
	_possible_drag_start_pos = level.get_global_mouse_position()


func _on_Inventory_item_double_click(idx):
	var item = _inventory[idx]
	remove_item_from_inventory(idx)
	open_merger(item)
