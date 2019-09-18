class_name Level
extends Node2D

onready var balls: Node2D = $Balls
onready var exits: Node2D = $Exits
onready var starting_items: Node2D = $StartingItems
onready var level_ui: LevelUI = $LevelUI


func _ready():
	level_ui.add_items(starting_items.get_children())
