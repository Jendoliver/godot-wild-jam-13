class_name Level
extends Node2D

onready var balls: Node2D = $Balls
onready var exits: Node2D = $Exits
onready var items: Node2D = $Items
onready var level_ui: LevelUI = $LevelUI


func _ready():
	level_ui.add_items_to_inventory(items.get_children())
