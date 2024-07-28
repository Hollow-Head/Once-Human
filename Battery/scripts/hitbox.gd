extends Area2D

class_name Hitbox

var belongsToEnemy : bool
var _damage : float
var _knockbackForce : float

func _ready():
	if not get_parent() is Weapon:
		printerr("The parent of class Hitbox need to be from type Weapon")
		get_tree().quit(-1)
		
	belongsToEnemy = get_parent().belongsToEnemy
	
	if belongsToEnemy:
		connect("body_entered", body_entered)
		_damage = get_parent().damage
		_knockbackForce = get_parent().knockbackForce

func attack_enemy(damage : float, knockbackForce : float) -> void:
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("Enemy"):
			var direction = get_parent().global_position.direction_to(body.global_position)
			body.receive_damage(self, damage, direction, knockbackForce)

func bullet_attack_enemy(damage : float, knockbackForce : float) -> void:
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("Enemy"):
			body.receive_damage(self, damage, get_parent().direction, knockbackForce)
			get_parent().queue_free()

func body_entered(body : Node2D):
	if "Player" in body.name:
		var direction = get_parent().global_position.direction_to(body.global_position)
		body.receive_damage(self, _damage, direction, _knockbackForce)
