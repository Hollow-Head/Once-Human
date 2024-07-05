extends Node2D

class_name Weapon

## The max distance the Weapon can be away from Player
@export var radius : float = 100

func _process(delta):
	rotateAroundPlayer()

func rotateAroundPlayer():
	global_position = Player.player.global_position
	var distanceToMouse = global_position.distance_to(get_global_mouse_position())
	if distanceToMouse > radius:
		distanceToMouse = radius
	var angle = global_position.angle_to_point(get_global_mouse_position())
	global_position = (Vector2(cos(angle), sin(angle)) * distanceToMouse) + Player.player.global_position
	
	rotate(-rotation)
	rotate(angle)
