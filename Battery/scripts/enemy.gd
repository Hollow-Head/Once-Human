extends Entity

class_name Enemy

var direction : Vector2

@export_enum("BLUE (PAPER)", "RED (PLASTIC)", "GREEN (GLASS)", "YELLOW (METAL)") var typeOfEnemy = 0

@export_category("Drop")

@export_group("Experience")
@export_range(0, 10000) var min_experience := 0
@export_range(0, 10000) var max_experience := 10
@export var experience_point_scene : PackedScene

@export_group("Item")
@export_range(0, 10000) var min_item := 0
@export_range(0, 10000) var max_item := 3
@export var item_drop_scene : PackedScene

@onready var bodySprite : Sprite2D = $Body

func _ready():
	add_to_group("Enemy")
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
	dead.connect(_deadSignal)
	
	current_speed = SPEED
	
	if min_experience > max_experience or min_item > max_item:
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
	_drop_experience_point()
	_drop_item()
	var explosion = Global.explosion_particle_scene.instantiate()
	explosion.global_position = global_position
	get_tree().current_scene.add_child(explosion)
	queue_free()

func _drop_experience_point():
	var quantity_of_experience_points = Global.rng.randi_range(min_experience, max_experience)
	for n in quantity_of_experience_points:
		var experience_point = experience_point_scene.instantiate()
		experience_point.global_position = global_position
		experience_point.throw_to_random_direction()
		get_tree().current_scene.add_child(experience_point)

func _drop_item():
	var quantity_of_item = Global.rng.randi_range(min_item, max_item)
	for n in quantity_of_item:
		var item = item_drop_scene.instantiate()
		item.global_position = global_position
		item.throw_to_random_direction()
		get_tree().current_scene.add_child(item)
