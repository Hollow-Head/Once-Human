extends Node

var _spawnTimer := GlobalTimer.new()
var spawnDelay : float = 1.5

var _x := 0
var _spawn_rate_timer := GlobalTimer.new()
var _spawn_rate : int
var _update_rate_delay := 60

var rng := RandomNumberGenerator.new()

var cameraRect : Rect2

@onready var enemy_scene_red = preload("res://scenes/Enemies/enemy_red.tscn")
@onready var enemy_scene_blue = preload("res://scenes/Enemies/enemy_blue.tscn")
@onready var enemy_scene_yellow = preload("res://scenes/Enemies/enemy_yellow.tscn")
@onready var enemy_scene_green = preload("res://scenes/Enemies/enemy_green.tscn")
enum enemy_id{RED, BLUE, YELLOW, GREEN}

enum directionToSpawn{LEFT, RIGHT, UP, DOWN}

func _ready():
	Global.game_scene_entered_tree.connect(_game_scene_entered)
	Global.game_scene_exited_tree.connect(_game_scene_exited)
	
	add_child(_spawnTimer)
	_spawnTimer.timeout.connect(_spawnTimerTimeout)
	
	add_child(_spawn_rate_timer)
	_spawn_rate_timer.timeout.connect(_spawn_rate_timeout)
	#_update_spawn_rate()

func _spawnTimerTimeout():
	for n in _spawn_rate:
		spawnOutsideCameraRandom()

func updateCameraRect():
	cameraRect = Player.player.get_viewport_rect()
	cameraRect.position = Player.player.global_position
	cameraRect.size /= Camera.camera.zoom

func spawnOutsideCameraRandom():
	updateCameraRect()
	
	var enemy : CharacterBody2D
	var type := rng.randi_range(0, enemy_id.size() - 1)
	match type:
		enemy_id.RED:
			enemy = enemy_scene_red.instantiate()
		enemy_id.BLUE:
			enemy = enemy_scene_blue.instantiate()
		enemy_id.YELLOW:
			enemy = enemy_scene_yellow.instantiate()
		enemy_id.GREEN:
			enemy = enemy_scene_green.instantiate()
	
	var direction = rng.randi_range(0, 3)
	var distanceFromEdge = 600
	
	match direction:
		directionToSpawn.LEFT:
			var leftPos = cameraRect.position.x - (cameraRect.size.x / 2) - distanceFromEdge
			var minY = cameraRect.position.y - (cameraRect.size.y / 2)
			var maxY = cameraRect.position.y + (cameraRect.size.y / 2)
			enemy.global_position = Vector2(leftPos, rng.randi_range(minY, maxY))
		directionToSpawn.RIGHT:
			var rightPos = cameraRect.position.x + (cameraRect.size.x / 2) + distanceFromEdge
			var minY = cameraRect.position.y - (cameraRect.size.y / 2)
			var maxY = cameraRect.position.y + (cameraRect.size.y / 2)
			enemy.global_position = Vector2(rightPos, rng.randi_range(minY, maxY))
		directionToSpawn.UP:
			var upPos = cameraRect.position.y - (cameraRect.size.y / 2) - distanceFromEdge
			var minX = cameraRect.position.x - (cameraRect.size.x / 2)
			var maxX = cameraRect.position.x + (cameraRect.size.x / 2)
			enemy.global_position = Vector2(rng.randi_range(minX, maxX), upPos)
		directionToSpawn.DOWN:
			var downPos = cameraRect.position.y + (cameraRect.size.y / 2) + distanceFromEdge
			var minX = cameraRect.position.x - (cameraRect.size.x / 2)
			var maxX = cameraRect.position.x + (cameraRect.size.x / 2)
			enemy.global_position = Vector2(rng.randi_range(minX, maxX), downPos)
	
	get_tree().current_scene.add_child(enemy)

func start(spawnDelay : float) -> void:
	_spawnTimer.paused = false
	self.spawnDelay = spawnDelay
	_spawnTimer.start(spawnDelay)

func stop() -> void:
	_spawnTimer.paused = true

func resume() -> void:
	_spawnTimer.paused = false

func reset() -> void:
	_x = 0
	_spawn_rate = 0
	_update_spawn_rate()

func _update_spawn_rate():
	#f(x) = 2 * x + 1
	_spawn_rate = (2 * _x) + 1
	_spawn_rate_timer.the_start(_update_rate_delay)
	spawnDelay += 1.0
	_x += 1

func _spawn_rate_timeout():
	_update_spawn_rate()

func _game_scene_entered():
	start(spawnDelay)

func _game_scene_exited():
	stop()
