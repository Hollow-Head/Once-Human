extends Node

signal choosed_upgrade

enum upgrades{INCREASE_PLAYER_SPEED, INCREASE_PLAYER_LIFE, INCREASE_XP_MODIFIER, INCREASE_PLAYER_DAMAGE}

var _is_showing_upgrades : bool

var upgradeScene := preload("res://scenes/Upgrades/upgrade_ui.tscn")
var upgradeNode : Node2D

func _ready():
	upgradeNode = upgradeScene.instantiate()

func _process(delta):
	#if Input.is_action_just_pressed("ui_up"): #and Global.get_time_speed() == 1.0:
		#Global.set_time_speed_except_player(0.1) ##TODO IF UNDER 0.1, DOESN'T WORK, FIX LATER
	#if Input.is_action_just_pressed("ui_down"): #and Global.get_time_speed() != 1.0:
		#Global.reset_time_speed()
	pass

func is_showing_upgrades() -> bool:
	return _is_showing_upgrades

func calc_percentage(percentage : float) -> float:
	return percentage / 100

func show_upgrades() -> void:
	if is_showing_upgrades():
		return
	Global.pause(self)
	_is_showing_upgrades = true
	get_tree().current_scene.add_child(upgradeNode)
	#upgradeNode.global_position = Camera.camera.global_position# / Camera.camera.zoom
	#upgradeNode.global_position.y -= (225 * upgradeNode.scale.y) / Camera.camera.zoom.y

func hide_upgrades() -> void:
	_is_showing_upgrades = false
	Global.resume()
	get_tree().current_scene.remove_child(upgradeNode)

func choose_upgrade(choice : int, percentage : int = 0, quantity : int = 0):
	match choice:
		upgrades.INCREASE_PLAYER_SPEED:
			increase_player_speed(percentage)
		upgrades.INCREASE_PLAYER_LIFE:
			increase_player_life(quantity)
		upgrades.INCREASE_XP_MODIFIER:
			increase_xp_modifier(percentage)
		upgrades.INCREASE_PLAYER_DAMAGE:
			increase_player_damage(percentage)
	hide_upgrades()

func increase_player_speed(percentage : int):
	Player.player.speed_modifier += Player.player.speed_modifier * calc_percentage(percentage)

func increase_player_life(quantity : int):
	Player.player.life += quantity

func increase_xp_modifier(percentage : int):
	Player.player.xp_modifier += Player.player.xp_modifier * calc_percentage(percentage)

func increase_player_damage(percentage : int):
	Player.player.damage_modifier += Player.player.damage_modifier * calc_percentage(percentage)
