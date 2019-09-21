# http://learn.leighcotnoir.com/artspeak/elements-color/primary-colors/
extends Node

enum Palette { RED, GREEN, BLUE, YELLOW, MAGENTA, CYAN, WHITE, BLACK }

var palette = {
	Palette.RED: Color(255, 0, 0),
	Palette.GREEN: Color(0, 255, 0),
	Palette.BLUE: Color(0, 0, 255),
	Palette.YELLOW: Color(255, 255, 0),
	Palette.MAGENTA: Color(255, 0, 255),
	Palette.CYAN: Color(0, 255, 255),
	Palette.WHITE: Color(255, 255, 255),
	Palette.BLACK: Color(0, 0, 0)
}


# Returns null on invalid color merge
func merge(items: Array):
	var color = Color(0, 0, 0)
	for item in items:
		color += item.get_color()
	return color if is_valid(color) else null


func is_valid(color: Color) -> bool:
	return color in palette.values()
