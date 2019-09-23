class_name Level
extends Node2D

onready var balls: Node2D = $Balls
onready var exits: Node2D = $Exits
onready var items: Node2D = $Items
onready var level_ui: LevelUI = $LevelUI

var is_merger_open = false setget set_merger_open

func _ready():
	for item in items.get_children():
		level_ui.add_item_to_inventory(item)
		item.level = self
	
	level_ui.connect("merger_state_changed", self, "set_merger_open")
	level_ui.connect("item_merged", self, "_on_item_merged")
	DragDrop.connect("item_dropped", self, "_on_item_dropped")

func set_merger_open(is_open):
	is_merger_open = is_open


func add_item_to_inventory(item):
	level_ui.add_item_to_inventory(item)


func _on_item_dropped(item, where, mouse_pos, mergeable_items):
	if where == DropArea.Kind.LEVEL:
		item.global_position = mouse_pos
		item.set_placement_level()
		add_child(item)


func _on_item_merged(_item, at_pos):
	items.add_child(_item)
	_item.show()
	_item.level = self
	print(_item.repr())
