# http://learn.leighcotnoir.com/artspeak/elements-color/primary-colors/
class_name Colors
extends Node

# Keep on pair with Item.gd
var palette = {
	"red": Color(255, 0, 0),
	"green": Color(0, 255, 0),
	"blue": Color(0, 0, 255),
	"yellow": Color(255, 255, 0),
	"magenta": Color(255, 0, 255),
	"cyan": Color(0, 255, 255),
	"white": Color(255, 255, 255),
	"black": Color(0, 0, 0)
}


# Returns null on invalid color merge
func merge(items: Array):
	var color = Color(0, 0, 0)
	for item in items:
		color += item.get_color()
	return color if is_valid(color) else null


func is_valid(color: Color) -> bool:
	return color in palette.values()
