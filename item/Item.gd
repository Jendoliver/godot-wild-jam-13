class_name Item
extends RigidBody2D

onready var sprite: Sprite = $Sprite
onready var collision: CollisionPolygon = $Collision
onready var inventory_index: int = -1
