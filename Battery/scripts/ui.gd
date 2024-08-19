extends Node2D

@onready var ammo_text = $AmmoUI/Ammo

var is_fire_gun : bool

var _initial_scale : Vector2

func _ready():
	is_fire_gun = Player.player.weapon is FireGun
	_initial_scale = scale

func _process(delta):
	if Global.is_paused():
		if is_fire_gun:
			ammo_text.text = "\n[wave amp=0.0 freq=0.0] " + str(Player.player.weapon.ammo) + "/" + str(
				Player.player.weapon.max_ammo) + " [/wave]"
		return
	
	$Interface/LifeUI/Control/MarginContainer/Life.text = str(Player.player.life)
	
	var pos = Camera.camera.global_position - ((Camera.camera.get_viewport_rect().size / 2) / Camera.camera.zoom)
	$Interface.global_position = pos
	$Interface.global_position += Camera.camera.offset
	
	$Interface.scale = (_initial_scale / Camera.camera.zoom)
	$AmmoUI/Ammo.scale = (_initial_scale / Camera.camera.zoom)
	
	if is_fire_gun:
		ammo_text.global_position = get_global_mouse_position()
		ammo_text.global_position.x -= (ammo_text.size.x / Camera.camera.zoom.x) / 4
		ammo_text.global_position.y += 25 / Camera.camera.zoom.y
		ammo_text.text = "\n[wave amp=20.0 freq=5.0] " + str(Player.player.weapon.ammo) + "/" + str(
			Player.player.weapon.max_ammo) + " [/wave]"
