extends Node

var _spawnTimer := Timer.new()
var spawnDelay : float = 1.5

var rng := RandomNumberGenerator.new()

var cameraRect : Rect2

var enemyScene = preload("res://scenes/enemy.tscn")

enum directionToSpawn{LEFT, RIGHT, UP, DOWN}

func _ready():
	add_child(_spawnTimer)
	_spawnTimer.timeout.connect(_spawnTimerTimeout)
	_spawnTimer.start(spawnDelay)

func _spawnTimerTimeout():
	spawnOutsideCameraRandom()

func updateCameraRect():
	cameraRect = Player.player.get_viewport_rect()
	cameraRect.position = Player.player.global_position

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
	
	get_node("/root/Main/").add_child(enemy)

func start(spawnDelay : float) -> void:
	self.spawnDelay = spawnDelay
	_spawnTimer.start(spawnDelay)

func stop() -> void:
	_spawnTimer.stop()

func resume() -> void:
	start(spawnDelay)
