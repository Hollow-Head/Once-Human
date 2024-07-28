extends Timer

class_name GlobalTimer

var the_wait_time : float
var wait_time_const : float
var _last_time_speed : float = 1.0

func _ready():
	Global.paused_changed.connect(_paused_changed)
	Global.time_changed.connect(_time_changed)
	timeout.connect(_timeout)

func _paused_changed(is_paused : bool):
	paused = is_paused

func _time_changed(time_speed : float):
	if not is_stopped():
		if _last_time_speed < 1:
			start(adjusted_time(time_left, _last_time_speed * 100))
		else:
			start(adjusted_time(time_left, (1 / _last_time_speed)))
		start(adjusted_time(time_left, time_speed))
		_last_time_speed = time_speed

func _timeout():
	start(adjusted_time(the_wait_time, Global.get_time_speed()))

func the_start(wait_time := 0.0):
	the_wait_time = wait_time
	start(the_wait_time)

func adjusted_time(time_left : float, time_speed : float) -> float:
	return time_left / time_speed
