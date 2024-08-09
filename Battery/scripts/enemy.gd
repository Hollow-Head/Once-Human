extends Entity

class_name Enemy

var direction : Vector2

@export_enum("BLUE (PAPER)", "RED (PLASTIC)", "GREEN (GLASS)", "YELLOW (METAL)") var typeOfEnemy = 0
@export_category("Drop")
@export_range(0, 10000) var min := 0
@export_range(0, 10000) var max := 10
@export var experience_point_scene : PackedScene

@onready var bodySprite : Sprite2D = $Body

func _ready():
	add_to_group("Enemy")
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
	dead.connect(_deadSignal)
	
	current_speed = SPEED
	
	if min > max:
		printerr("The MINIMUM drop can't be greater than the MAXIMUM drop")
		get_tree().quit(-1)

func _physics_process(delta):
	if Global.is_paused():
		return
	
	if Player.player.global_position.x < global_position.x:
		bodySprite.flip_h = false
	else:
		bodySprite.flip_h = true
	
	if not is_in_knockback_state():
		direction = global_position.direction_to(Player.player.global_position)
		velocity = current_speed * direction
	else:
		velocity = current_speed * knockbackDirection * knockbackForce
	velocity *= Global.get_time_speed()
	move_and_slide()

func _deadSignal():
	_kill()

func _kill():
	var quantity_of_experience_points = Global.rng.randi_range(min, max)
	for n in quantity_of_experience_points:
		var experience_point = experience_point_scene.instantiate()
		experience_point.global_position = global_position
		experience_point.throw_to_random_direction()
		get_node("/root/Main/").add_child(experience_point)
	queue_free()
