class_name LevelUI
extends CanvasLayer

signal merger_state_changed(is_active)

export var drag_min_distance = 10

onready var inventory = $Menu/Inventory
onready var merger = $Merger
onready var level_drop_area = $LevelDropArea
onready var level = get_node('..')  # Bad practice pero vamos apuradetes

var _possible_dragged_item: Item
var _possible_drag_start_pos


func _ready():
	DragDrop.connect("item_dropped", self, "_on_item_dropped")
	connect("item_clicky", self, "_on_Inventory_item_clicky")
	connect("item_double_clicky", self, "_on_Inventory_item_double_clicky")

func _input(event):
	if not (event.is_action_released("primary")
	and _possible_dragged_item != null
	and _possible_drag_start_pos != null):
		return

	var current_mouse_pos = level.get_global_mouse_position()
	if current_mouse_pos.distance_to(_possible_drag_start_pos) > drag_min_distance:
		DragDrop.drag(_possible_dragged_item)
		inventory.remove_item(_possible_dragged_item)
	_possible_dragged_item = null
	_possible_drag_start_pos = null

func add_items_to_inventory(items: Array):
	for item in items:
		inventory.add_item(item)


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
		inventory.add_item(item)


func _on_Inventory_item_clicky(item: Item):
	print("clicky")
	_possible_dragged_item = item
	_possible_drag_start_pos = level.get_global_mouse_position()


func _on_Inventory_item_double_clicky(item: Item):
	print("double_clicky")
	inventory.remove_item(item)
	open_merger(item)

