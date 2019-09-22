# http://learn.leighcotnoir.com/artspeak/elements-color/primary-colors/
extends Node

enum Palette { RED, GREEN, BLUE, YELLOW, MAGENTA, CYAN, WHITE, BLACK }

var palette = {
	Palette.RED: Color(1, 0, 0),
	Palette.GREEN: Color(0, 1, 0),
	Palette.BLUE: Color(0, 0, 1),
	Palette.YELLOW: Color(1, 1, 0),
	Palette.MAGENTA: Color(1, 0, 1),
	Palette.CYAN: Color(0, 1, 1),
	Palette.WHITE: Color(1, 1, 1),
	Palette.BLACK: Color(0, 0, 0)
}


# Returns null on invalid color merge
func merge(colors: Array) -> Color:
	var color = Color(0, 0, 0)
	for _color in colors:
		color += _color
	color.r = min(color.r, 1.0)
	color.g = min(color.g, 1.0)
	color.b = min(color.b, 1.0)
	return color if is_valid(color) else null


func merge_items(items: Array) -> Color:
	var colors = []
	for item in items:
		colors.append(item.color)
	return merge(colors)


func is_valid(color: Color) -> bool:
	for _color in palette.values():
		if color.r == _color.r \
		and color.g == _color.g \
		and color.b == _color.b:
			return true

	return false


func tween_sprite(sprite: Sprite, 
	from: Color, to: Color, tween = null, 
	duration = 3.0, transition = Tween.TRANS_ELASTIC,
	easing = Tween.EASE_IN):

		if tween == null:
			tween = Tween.new()
			var root = get_node('/root')
			root.add_child(tween)
			tween.connect("tween_completed", tween, "queue_free")

		tween.interpolate_property(
			sprite, 'modulate', 
			from, to, duration, 
			transition, duration, easing)
		tween.start()
