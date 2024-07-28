extends Entity

class_name Player

var direction

static var player : CharacterBody2D

var level := 0
var _points_to_level_up : int
var _x := 1
var _experiencePoints = 0.0

@export_range(0, 10000) var pickRadius := 0

func _ready():
	_calculate_next_level()
	
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
	player = self
	
	current_speed = SPEED

func _physics_process(delta):
	if Global.is_paused():
		return
	
	## REMOVE THIS LATER
	if Input.is_action_just_pressed("ui_accept"):
		var groupMember = get_tree().get_nodes_in_group("Enemy")
		for n in groupMember:
			n.life = 0
	
	if not isInKnockbackState():
		direction = Input.get_vector("Move Left", "Move Right", "Move Up", "Move Down")
		if direction:
			velocity = direction * current_speed
		else:
			velocity.x = move_toward(velocity.x, 0, current_speed)
			velocity.y = move_toward(velocity.y, 0, current_speed)
	else:
		velocity = knockbackDirection * knockbackForce * current_speed
	
	velocity *= Global.get_player_time_speed()

	move_and_slide()

func _calculate_next_level() -> void:
	## f(x) = 2x^(2) - x + 10 | NORMAL
	## f(x) = 3x^(2) - 4x + 11 OR f(x) = 5x^(2) - 3x + 9 | HARD
	_points_to_level_up = (2 * pow(_x, 2)) - (_x) + (10) ## NORMAL
	_x += 1

func _check_level_up():
	if _experiencePoints >= _points_to_level_up:
		_experiencePoints = roundi(_experiencePoints) - _points_to_level_up
		level += 1
		_level_up()
		_calculate_next_level()
		_check_level_up() ## Returns the same functions until _experiencePoints is less than the _points_to_level_up

func _level_up():
	print("Leveled up to " + str(level))

func add_experience_points(quantity_of_points : float) -> void:
	_experiencePoints += quantity_of_points
	#print("Player have " + str(_experiencePoints) + " experience points")
	_check_level_up()
	 

func get_experience_points() -> int:
	return _experiencePoints
