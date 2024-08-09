extends Camera2D

class_name Camera

static var camera : Camera2D

static var radius : float = 100

var _relative_mouse : Vector2
var _direction : Vector2
var _distance : float

@export var random_strength : float = 30.0
@export var shake_fade : float = 5.0

static var shake_strength : float = 0.0

func _ready():
	camera = self

func _process(delta):
	if Global.is_paused():
		return
	
	#global_position = Player.player.global_position
	global_position = global_position.lerp(Player.player.global_position, 10 * delta)
	
	_relative_mouse = Player.player.global_position + get_viewport().get_mouse_position() - Vector2(get_viewport().size / 2)
	_direction = Player.player.global_position.direction_to(_relative_mouse)
	_distance = Player.player.global_position.distance_to(_relative_mouse)
	if _distance > radius:
		_distance = radius
	
	#global_position += _direction * _distance
	global_position = global_position.lerp(global_position + (_direction * _distance), 10 * delta)
	
	_handle_camera_shake(delta)


## CAMERA SHAKE: https://www.youtube.com/watch?v=LGt-jjVf-ZU
static func shake_camera(strength : float) -> void:
	#shake_strength = random_strength
	shake_strength = strength

func _handle_camera_shake(delta : float):
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength, 0, shake_fade * delta)
		offset = _random_offset()

func _random_offset() -> Vector2:
	return Vector2(Global.rng.randf_range(-shake_strength, shake_strength), Global.rng.randf_range(
		-shake_strength, shake_strength))
