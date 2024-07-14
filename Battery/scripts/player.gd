extends Entity

class_name Player

const SPEED = 800.0
var direction

static var player : CharacterBody2D

var level := 0
var _experiencePoints = 0.0

func _ready():
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
	player = self

func _physics_process(delta):
	
	if Input.is_action_just_pressed("ui_accept"):
		var groupMember = get_tree().get_nodes_in_group("Enemy")
		for n in groupMember:
			n.life = 0
	
	if not isInKnockbackState():
		direction = Input.get_vector("Move Left", "Move Right", "Move Up", "Move Down")
		if direction:
			velocity = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.y = move_toward(velocity.y, 0, SPEED)
	else:
		velocity = knockbackDirection * knockbackForce * SPEED

	move_and_slide()

func add_experience_points(quantity_of_points : float) -> void:
	_experiencePoints += quantity_of_points

func get_experience_points() -> int:
	return _experiencePoints
