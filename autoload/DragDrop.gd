extends Node2D

signal drop(dragged)

var _dragged: Item


func _ready():
	set_process(false)


func _process(delta):
	_dragged.set_global_position(get_global_mouse_position())
	if Input.is_action_just_released("interact"):
		emit_signal("drop", _dragged)
		set_process(false)


func drag(item: Item):
	item.get_owner().remove_child(item)
	add_child(item)
	_dragged = item
	set_process(true)
	_dragged.collision.disabled = true


func drop():
	_dragged.collision.disabled = false


func is_currently_dragging() -> bool:
	return _dragged != null


func get_currently_dragged() -> Item:
	return _dragged
