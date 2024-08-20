extends Area2D

class_name Hurtbox

var entity : Entity
@export var belongs_to_enemy : bool

func _ready():
	entity = get_parent()
	if belongs_to_enemy:
		add_to_group("Enemy Hurtbox")
	else:
		add_to_group("Player Hurtbox")

func receive_damage(body : Node2D, damage : float, direction : Vector2, knockbackForce : float):
	if not entity.invulnerable:
		entity.receive_damage(body, damage, direction, knockbackForce)

func receive_knockback(direction : Vector2, knockbackForce : float):
	if not entity.invulnerable:
		entity.receive_knockback(direction, knockbackForce)
