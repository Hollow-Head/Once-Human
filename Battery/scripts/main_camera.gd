extends Camera2D

func _process(delta):
	if Global.is_paused():
		return
	global_position = Player.player.global_position
