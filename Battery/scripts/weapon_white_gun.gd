extends Weapon

class_name WhiteGun

@export var hitbox : Hitbox

func _physics_process(delta):
	if belongsToEnemy:
		set_physics_process(false)
		return
	if Input.is_action_just_pressed("Attack"):
		hitbox.attack_enemy(damage, knockbackForce)
