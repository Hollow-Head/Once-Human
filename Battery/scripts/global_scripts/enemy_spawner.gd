extends Node

var _spawnTimer := GlobalTimer.new()
var spawnDelay : float = 1.5

var _x := 0
var _spawn_rate_timer := GlobalTimer.new()
var _spawn_rate : int
var _update_rate_delay := 60

var rng := RandomNumberGenerator.new()

var cameraRect : Rect2

var enemyScene = preload("res://scenes/Enemies/enemy.tscn")

enum directionToSpawn{LEFT, RIGHT, UP, DOWN}

func _ready():
	Global.game_scene_entered_tree.connect(_game_scene_entered)
	Global.game_scene_exited_tree.connect(_game_scene_exited)
	
	add_child(_spawnTimer)
	_spawnTimer.timeout.connect(_spawnTimerTimeout)
	
	add_child(_spawn_rate_timer)
	_spawn_rate_timer.timeout.connect(_spawn_rate_timeout)
	_update_spawn_rate()

func _spawnTimerTimeout():
	for n in _spawn_rate:
		spawnOutsideCameraRandom()

func updateCameraRect():
	cameraRect = Player.player.get_viewport_rect()
	cameraRect.position = Player.player.global_position
	cameraRect.size /= Camera.camera.zoom

func spawnOutsideCameraRandom():
	updateCameraRect()
	
	var enemy : CharacterBody2D = enemyScene.instantiate()
	
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

func _update_spawn_rate():
	#f(x) = 2 * x + 1
	_spawn_rate = (2 * _x) + 1
	_spawn_rate_timer.the_start(_update_rate_delay)
	_x += 1

func _spawn_rate_timeout():
	_update_spawn_rate()

func _game_scene_entered():
	start(spawnDelay)

func _game_scene_exited():
	stop()
