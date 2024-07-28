@icon("res://assets/nodeIcons/bullet.png")

extends Weapon

class_name Bullet

@export_range(1, 10000) var speed : int = 800
@export var hitbox : Hitbox

var direction : Vector2

func _process(delta):
	if Global.is_paused():
		return
	if direction:
		global_position += direction * speed * delta * Global.get_time_speed()
		hitbox.bullet_attack_enemy(damage, knockbackForce)

func shoot(direction : Vector2, belongsToEnemy : bool) -> void:
	self.direction = direction
	hitbox.belongsToEnemy = belongsToEnemy
