extends Node2D

class_name Weapon

## The max distance the Weapon can be away from Player
@export var radius : float = 100

@export var attackDelay : float
@export var damage : float
@export var knockbackForce : float
@export var belongsToEnemy : bool

func _process(delta):
	if belongsToEnemy:
		set_process(false)
		return
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
