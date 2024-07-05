extends Weapon

class_name WhiteGun

@export var attackDelay : float
@export var damage : float
@export var knockbackForce : float

@export var hitbox : Hitbox

@export var belongsToEnemy : bool

func _physics_process(delta):
	if belongsToEnemy:
		set_physics_process(false)
	if Input.is_action_just_pressed("Attack"):
		hitbox.attack_enemy(damage, knockbackForce)
