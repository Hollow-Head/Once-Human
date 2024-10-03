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

var _initial_zoom : Vector2

func _ready():
	camera = self
	_initial_zoom = zoom

func _process(delta):
	if Global.is_paused():
		return
	
	if Input.is_action_just_pressed("Zoom In") and zoom <= Vector2(1.5, 1.5):
		zoom += Vector2(0.05, 0.05)
	elif Input.is_action_just_pressed("Zoom Out") and zoom >= Vector2(0.3, 0.3):
		zoom -= Vector2(0.05, 0.05)
	elif Input.is_action_just_pressed("Reset Zoom"):
		zoom = _initial_zoom
	
	#global_position = Player.player.global_position
	global_position = global_position.lerp(Player.player.global_position, 10 * delta)
	if get_window().mode == Window.MODE_WINDOWED:
		_relative_mouse = Player.player.global_position + get_viewport().get_mouse_position() - Vector2(get_viewport().size / 2)
	else:
		_relative_mouse = Player.player.global_position + get_viewport().get_mouse_position() - Vector2(get_viewport().size / 3.5)
	_direction = Player.player.global_position.direction_to(_relative_mouse) / zoom
	_distance = Player.player.global_position.distance_to(_relative_mouse)
	if _distance > radius:
		_distance = radius
	
	#global_position += _direction * _distance
	global_position = global_position.lerp(global_position + (_direction * _distance), 10 * delta)
	
	_handle_camera_shake(delta)


## CAMERA SHAKE: https://www.youtube.com/watch?v=LGt-jjVf-ZU
static func shake_camera(strength : float) -> void:
	#shake_strength = random_strength
	shake_strength = strength / Camera.camera.zoom.x

func _handle_camera_shake(delta : float):
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength, 0, shake_fade * delta)
		offset = _random_offset()

func _random_offset() -> Vector2:
	return Vector2(Global.rng.randf_range(-shake_strength, shake_strength), Global.rng.randf_range(
		-shake_strength, shake_strength))
