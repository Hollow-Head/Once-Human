@icon("res://assets/nodeIcons/fireGun.png")

extends Weapon

class_name FireGun

@export var bulletScene : PackedScene
@export var gun_barrel : Marker2D

@export_range(1, 10000) var max_ammo := 1
var ammo : int
@export_range(1, 10000) var ammo_per_shot := 1
@export_range(0.01, 10000) var reload_delay := 0.1
var reload_timer := GlobalTimer.new()

@export_range(0, 180) var bullet_spread : float

var direction : Vector2

@onready var reload_scene : PackedScene = preload("res://scenes/reload.tscn")
var reload : Node2D

func _ready():
	ammo = max_ammo
	
	reload = reload_scene.instantiate()
	
	add_child(reload_timer)
	reload_timer.timeout.connect(_reload_timeout)
	reload_timer.wait_time = reload_delay

func _physics_process(delta):
	if Global.is_paused():
		return
	
	if ammo <= 0:
		if reload_timer.is_stopped():
			reload_timer.the_start()
			get_tree().current_scene.add_child(reload)
		else:
			reload.play_reload(reload_timer.wait_time - reload_timer.time_left, reload_delay)
		return
	
	if not belongsToEnemy:
		if not reload_timer.is_stopped():
			reload.play_reload(reload_timer.wait_time - reload_timer.time_left, reload_delay)
		elif Input.is_action_just_pressed("Reload") and ammo < max_ammo:
			get_tree().current_scene.add_child(reload)
			reload_timer.the_start()
		
		if Input.is_action_just_pressed("Attack"):
			if reload.is_inside_tree():
				get_tree().current_scene.remove_child(reload)
			reload_timer.stop()
			ammo -= ammo_per_shot
			Camera.shake_camera(7.5)
			direction = Player.player.global_position.direction_to(get_global_mouse_position())
			shoot(direction)

func shoot(direction : Vector2):
	var bullet : Bullet = bulletScene.instantiate()
	if Player.player.direction:
		direction = direction.rotated(deg_to_rad(Global.rng.randf_range(-bullet_spread, bullet_spread)))
	bullet.shoot(gun_barrel.global_position, direction, belongsToEnemy)
	get_tree().current_scene.add_child(bullet)

func _reload_timeout():
	get_tree().current_scene.remove_child(reload)
	ammo = max_ammo
	reload_timer.stop()
