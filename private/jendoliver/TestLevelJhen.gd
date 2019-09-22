extends Level


func _on_LevelUI_item_merged(item):
	items.add_child(item)
	for item in items.get_children():
		print("Current items on level: ", item.name)
