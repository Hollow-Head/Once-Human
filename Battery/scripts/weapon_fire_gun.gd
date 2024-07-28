@icon("res://assets/nodeIcons/fireGun.png")

extends Weapon

class_name FireGun

@export var bulletScene : PackedScene
@export var gunBarrel : Marker2D
var direction : Vector2

func _physics_process(delta):
	if Global.is_paused():
		return
		
	if not belongsToEnemy:
		if Input.is_action_just_pressed("Attack"):
			direction = Player.player.global_position.direction_to(get_global_mouse_position())
			shoot(direction)

func shoot(direction : Vector2):
	var bullet : Bullet = bulletScene.instantiate()
	bullet.shoot(direction, belongsToEnemy)
	bullet.global_position = gunBarrel.global_position
	bullet.look_at(get_global_mouse_position())
	get_node("/root/Main/").add_child(bullet)
