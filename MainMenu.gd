extends Control

onready var main_screen: Panel = $MainScreen
onready var credits: Panel = $Credits
onready var how_to_play: Panel = $HowToPlay
onready var game_title: Label = $MainScreen/GameTitle
onready var version: Label = $MainScreen/Version

var current_open_screen: Panel setget set_current_open_screen


func _ready():
	version.text = Version.as_str()
	current_open_screen = main_screen


func set_current_open_screen(new_open_screen: Panel):
	current_open_screen.hide()
	new_open_screen.show()
	current_open_screen = new_open_screen


func _on_Start_pressed():
	Levels.change_to('tutorial')


func _on_HowToPlay_pressed():
	set_current_open_screen(how_to_play)


func _on_Credits_pressed():
	set_current_open_screen(credits)


func _on_Exit_pressed():
	get_tree().quit()


func _on_Back_pressed():
	set_current_open_screen(main_screen)
