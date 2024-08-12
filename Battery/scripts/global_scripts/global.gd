extends Node

var rng := RandomNumberGenerator.new()

var _is_paused : bool

var _who_called_pause : Node

signal paused_changed(is_paused : bool)
signal time_changed(time_speed : float)

var _time_speed := 1.0
var _player_time_speed := 1.0

@onready var hit_particle_scene : PackedScene = preload("res://scenes/particles/hit_effect.tscn")
@onready var explosion_particle_scene : PackedScene = preload("res://scenes/particles/explosion_effect.tscn")

func _process(delta):
	if Input.is_action_just_pressed("Pause"):
		_is_paused = !_is_paused
		emit_signal("paused_changed", _is_paused)

func pause(the_caller : Node):
	_who_called_pause = the_caller
	_is_paused = true
	emit_signal("paused_changed", _is_paused)

func resume():
	_who_called_pause = null
	_is_paused = false
	emit_signal("paused_changed", _is_paused)

func is_paused() -> bool:
	return _is_paused

func get_the_pause_caller() -> Node:
	return _who_called_pause

func linear_function(min : float, max : float, value : float) -> float:
	## Formula de uma função linear
	## m = y2 - y1 / x2 - x1
	var m = (max - min) / (100 - 0) # 100% e 0%
	## b pode usar x1 e y1 ou x2 e y2
	var b = min - m * 0 # b = y - mx
	## FORMULA: y = mx + b
	## FORMULA PRA ACHAR A PORCENTAGEM: x = y - b / m 
	var result : float = (value - b) / m
	return result

func round_place(num,places) -> float:
	return (round(num * pow(10, places)) / pow(10, places))

#
## MAKE A FUNCTION THAT FADES TIME SPEED TO THE WISHED TIME SPEED
#

func set_time_speed(time_speed : float):
	if time_speed <= 0.0:
		_time_speed = 0.00001
		_player_time_speed = 0.00001
	else:
		_time_speed = time_speed
		_player_time_speed = time_speed
	emit_signal("time_changed", _time_speed)

func set_time_speed_except_player(time_speed : float):
	if time_speed <= 0.0:
		_time_speed = 0.00001
	else:
		_time_speed = time_speed
	emit_signal("time_changed", _time_speed)

func reset_time_speed():
	_time_speed = 1
	_player_time_speed = 1
	emit_signal("time_changed", _time_speed)

func get_time_speed() -> float:
	return _time_speed

func get_player_time_speed() -> float:
	return _player_time_speed
