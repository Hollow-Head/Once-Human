extends Entity

class_name Enemy

const SPEED = 300.0
var direction : Vector2

func _ready():
	add_to_group("Enemy")
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
	dead.connect(_deadSignal)

func _physics_process(delta):
	if not isInKnockbackState():
		direction = global_position.direction_to(Player.player.global_position)
		velocity = SPEED * direction
	else:
		velocity = SPEED * knockbackDirection * knockbackForce
	move_and_slide()

func _deadSignal():
	_kill()

func _kill():
	queue_free()
