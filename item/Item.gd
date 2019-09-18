class_name Item
extends RigidBody2D

const OUT_OF_INVENTORY = -1

onready var sprite: Sprite = $Sprite
onready var collision: CollisionPolygon = $Collision
var inventory_index: int = OUT_OF_INVENTORY
