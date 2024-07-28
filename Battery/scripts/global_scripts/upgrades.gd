extends Node

signal choosed_upgrade

enum upgrades{STEAM, OI}

func _process(delta):
	if Input.is_action_just_pressed("ui_up"): #and Global.get_time_speed() == 1.0:
		Global.set_time_speed_except_player(0.1) ##TODO IF UNDER 0.1, DOESN'T WORK, FIX LATER
	if Input.is_action_just_pressed("ui_down"): #and Global.get_time_speed() != 1.0:
		Global.reset_time_speed()

func show_upgrades() -> void:
	pass

func increase_player_speed(percentage : int):
	Player.player.current_speed *= (percentage / 100)
