class_name Level
extends Node2D

onready var balls: Node2D = $Balls
onready var exits: Node2D = $Exits
onready var items: Node2D = $Items
onready var level_ui: LevelUI = $LevelUI


var is_merger_open = false setget set_merger_open


func _ready():
	level_ui.add_items_to_inventory(items.get_children())
	level_ui.connect("merger_state_changed", self, "set_merger_open")


func set_merger_open(is_open):
	is_merger_open = is_open
