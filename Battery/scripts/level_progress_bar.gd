extends TextureProgressBar

var _initial_size_y : float
var _initial_scale_text : Vector2

func _ready():
	_initial_size_y = size.y
	_initial_scale_text = $MarginContainer.scale

func _process(delta):
	global_position = Camera.camera.global_position
	global_position.x -= Camera.camera.get_viewport_rect().size.x / 2 / Camera.camera.zoom.x
	global_position.y += Camera.camera.get_viewport_rect().size.y / 2 / Camera.camera.zoom.y
	global_position.y -= ((_initial_size_y / 2) + 15) / Camera.camera.zoom.y
	global_position += Camera.camera.offset
	
	size.x = Camera.camera.get_viewport_rect().size.x / Camera.camera.zoom.x
	size.y = _initial_size_y / Camera.camera.zoom.y
	
	$MarginContainer.global_position = global_position
	$MarginContainer.scale = _initial_scale_text / Camera.camera.zoom
	$MarginContainer.position.x += ((size.x / 2) - ($MarginContainer.size.x * _initial_scale_text.x/ 2) / Camera.camera.zoom.x)
	$MarginContainer.position.y += (30 / Camera.camera.zoom.y)
	
	max_value = Player.get_points_to_level_up()
	value = Player.get_experience_points()
	$MarginContainer/RichTextLabel.text = "Lvl. " + str(Player.player.level + 1)
