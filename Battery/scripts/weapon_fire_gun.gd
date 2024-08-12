@icon("res://assets/nodeIcons/fireGun.png")

extends Weapon

class_name FireGun

@export var bulletScene : PackedScene
@export var gun_barrel : Marker2D
var direction : Vector2

func _physics_process(delta):
	if Global.is_paused():
		return
		
	if not belongsToEnemy:
		if Input.is_action_just_pressed("Attack"):
			Camera.shake_camera(7.5)
			direction = Player.player.global_position.direction_to(get_global_mouse_position())
			shoot(direction)

func shoot(direction : Vector2):
	var bullet : Bullet = bulletScene.instantiate()
	bullet.shoot(gun_barrel.global_position, direction, belongsToEnemy)
	get_node("/root/Main/").add_child(bullet)
