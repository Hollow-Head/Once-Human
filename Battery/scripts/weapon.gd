extends Node2D

class_name Weapon

## The max distance the Weapon can be away from Player
@export var radius : float = 100

@export var attackDelay : float
@export var damage : float
@export var knockbackForce : float
@export var belongsToEnemy : bool

func _process(delta):
	if Global.is_paused():
		return
		
	if belongsToEnemy:
		set_process(false)
		return
	rotateAroundPlayer()

func rotateAroundPlayer():
	var mousePos = get_global_mouse_position()
	var playerPos = Player.player.global_transform.origin
	var distance = playerPos.distance_to(mousePos)
	var mouseDir = (mousePos - playerPos).normalized()
	if distance > radius:
		mousePos = playerPos + (mouseDir * radius)
	self.global_transform.origin = mousePos
	rotation = Player.player.get_angle_to(get_global_mouse_position())
