extends Node2D

var _initial_scale : Vector2

func _ready():
	_initial_scale = scale

func _process(delta):
	scale = (_initial_scale / Camera.camera.zoom)
	
	global_position = Player.player.global_position
	global_position.y -= 100

func play_reload(current_time : float, max_time : float):
	var diference = $Base/End.global_position.x - $Base/Start.global_position.x
	$Point.global_position = $Base/Start.global_position
	$Point.global_position.y -= 1 / Camera.camera.zoom.y
	$Point.global_position.x += diference * Global.linear_function(0.0, max_time, current_time) / 100
