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
		connect("area_entered", area_entered)
		_damage = get_parent().damage
		_knockbackForce = get_parent().knockbackForce

func attack_enemy(damage : float, knockbackForce : float) -> void:
	var areas = get_overlapping_areas()
	for area in areas:
		if area.is_in_group("Enemy Hurtbox"):
			var direction = get_parent().global_position.direction_to(area.global_position)
			area.receive_damage(self, damage * Player.player.damage_modifier, direction, knockbackForce)

func bullet_attack_enemy(damage : float, knockbackForce : float) -> void:
	var areas = get_overlapping_areas()
	for area in areas:
		if area.is_in_group("Enemy Hurtbox"):
			area.receive_damage(self, damage * Player.player.damage_modifier, get_parent().direction, knockbackForce)
			get_parent().queue_free()

func area_entered(area : Area2D):
	if area.is_in_group("Player Hurtbox"):
		var direction = get_parent().global_position.direction_to(area.global_position)
		area.receive_damage(self, _damage, direction, _knockbackForce)
