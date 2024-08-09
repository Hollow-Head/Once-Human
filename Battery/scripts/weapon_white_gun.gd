@icon("res://assets/nodeIcons/whiteGun.png")

extends Weapon

class_name WhiteGun

@export var hitbox : Hitbox

func _physics_process(delta):
	if Global.is_paused():
		return
	
	if belongsToEnemy:
		set_physics_process(false)
		return
	if Input.is_action_just_pressed("Attack"):
		Camera.shake_camera(7.5)
		hitbox.attack_enemy(damage, knockbackForce)
