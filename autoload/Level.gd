extends Node

const LEVEL_PATH = "res://level/"


func change_to(level_name: String):
	get_tree().change_scene(LEVEL_PATH + level_name + ".tscn")
