extends Node2D

signal drop(dragged)

var _dragged: Item
var _dragged_sprite: Sprite


func _ready():
	set_process(false)


func _process(delta):
	_dragged_sprite.global_position = get_global_mouse_position()
	print(get_global_mouse_position(), _dragged_sprite.global_position)
	if Input.is_action_just_released("interact"):
		emit_signal("drop", _dragged)
		print("drop")
#		set_process(false)


func drag(item: Item):
	var parent = item.get_node('..')
	parent.remove_child(item)
	_dragged = item
	
	_dragged_sprite = Sprite.new()
	_dragged_sprite.texture = item.sprite.texture.duplicate()
	_dragged_sprite.modulate.a = 150
	add_child(_dragged_sprite)
	
	item.sleeping = true
	_dragged.collision.disabled = true
	set_process(true)


func drop():
	_dragged.collision.disabled = false


func is_currently_dragging() -> bool:
	return _dragged != null


func get_currently_dragged() -> Item:
	return _dragged
