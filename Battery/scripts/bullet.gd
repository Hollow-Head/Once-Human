@icon("res://assets/nodeIcons/bullet.png")

extends Weapon

class_name Bullet

@export_range(1, 10000) var speed : int = 1600
@export var hitbox : Hitbox

var direction : Vector2

var _global_timer := GlobalTimer.new()

func _ready():
	add_child(_global_timer)
	_global_timer.timeout.connect(_timeout)
	_global_timer.the_start(15)

func _process(delta):
	if Global.is_paused():
		return
	if direction:
		global_position += direction * speed * delta * Global.get_time_speed()
		hitbox.bullet_attack_enemy(damage, knockbackForce)

func shoot(global_position : Vector2, direction : Vector2, belongsToEnemy : bool) -> void:
	self.global_position = global_position
	self.direction = direction
	hitbox.belongsToEnemy = belongsToEnemy
	look_at(global_position + direction)

func _timeout():
	queue_free()
