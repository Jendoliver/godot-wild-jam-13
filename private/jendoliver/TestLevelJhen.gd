extends Level

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	DragDrop.drag(starting_items.get_child(0))
