extends Item

class_name ExperiencePoint

@export_range(1, 100000) var quantityOfPoints := 1

## The speed that orbits the Player
@export var SPEED := 0.0
var current_speed : float

var direction : Vector2
var distance_to_player : float

var _throw_state : bool
var _throw_direction : Vector2
var _throw_speed : float = 250.0
var _random_force : float
var _throw_deceleration : float = 200.0

func _ready():
	pick_up.connect(_pick_up)

func _physics_process(delta):
	if Global.is_paused():
		return
	
	current_speed = SPEED
	
	if _throw_state and _throw_speed > 0:
		global_position += _throw_direction * _throw_speed * _random_force * delta * Global.get_time_speed()
	
	_throw_speed -= _throw_deceleration * delta * Global.get_time_speed()
	
	distance_to_player = global_position.distance_to(Player.player.global_position)
	if global_position.distance_to(Player.player.global_position) <= Player.player.pickRadius:
		direction = global_position.direction_to(Player.player.global_position)
		##The linear function returns the percentage, then, to calculate the actual value, I divide the percentage
		## by 100 and multiply by the value I want
		current_speed = SPEED * (Global.linear_function(Player.player.pickRadius, 0, distance_to_player) / 100)
		global_position += direction * current_speed * delta * Global.get_player_time_speed()

func _pick_up():
	Player.player.add_experience_points(quantityOfPoints)
	queue_free()

func throw_to_random_direction(min := 0, max := 360):
	if min > max:
		printerr("The MINIMUM value can't be greater than maximum value")
		get_tree().quit(-1)
	
	_throw_state = true
	var angle = deg_to_rad(Global.rng.randi_range(min, max))
	_throw_direction = Vector2.from_angle(angle)
	
	_random_force = Global.rng.randf_range(1.0, 2.0)
