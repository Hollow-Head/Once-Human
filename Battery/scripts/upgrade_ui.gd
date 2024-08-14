extends Node2D

var _initial_scale : Vector2

func _ready():
	_initial_scale = scale

func _process(delta):
	scale = _initial_scale / Camera.camera.zoom
	
	global_position = Camera.camera.global_position
	global_position.y -= (225 * scale.y)
