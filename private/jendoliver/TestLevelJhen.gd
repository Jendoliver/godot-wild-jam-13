extends Level

func _ready():
	print(Colors.merge([items.get_child(0), items.get_child(1)]))
