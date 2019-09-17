extends Node

var major = 0
var minor = 0
var patch = 1


func as_array() -> Array:
	return [major, minor, patch]


func as_dict() -> Dictionary:
	return {'major': major, 'minor': minor, 'patch': patch}


func as_str():
	return "v%s.%s.%s" % as_array()
