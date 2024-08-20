extends Entity

class_name Player

var direction

static var player : CharacterBody2D

var level := 0
static var _points_to_level_up : int
var _x := 1
static var _experiencePoints = 0.0

var speed_modifier := 1.0
var xp_modifier := 1.0
var damage_modifier := 1.0

static var _plastic_items := 0
static var _glass_items := 0
static var _paper_items := 0
static var _metal_items := 0

@export var accel : float = 7.5

@export_range(0, 10000) var pickRadius := 0

@export var weapon : Weapon

@onready var bodySprite : Sprite2D = $Body
@onready var bodyAnimation : AnimationPlayer = $Body/AnimationPlayer

@onready var hoodMarker : Marker2D = $Body/Marker2D
@onready var hoodSprite : Sprite2D = $Hood
@onready var hoodAnimation : AnimationPlayer = $Hood/AnimationPlayer

var seconds_from_before : float

var mouse_direction : Vector2

var changed_x : bool

##TODO I COULD HAD USED SIGNAL HERE, WHY I DIDN'T USED IT
var changed_y_body : bool
var changed_y_hood : bool

var is_running_backwards : bool

var smokeScene : PackedScene = preload("res://scenes/particles/walking_smoke.tscn")
@onready var smokeTimer := GlobalTimer.new() 

var has_power := true
var power_timer := GlobalTimer.new()
var power_timer_delay := 60.0

func _ready():
	_experiencePoints = 0
	
	_plastic_items = 0
	_glass_items = 0
	_paper_items = 0
	_metal_items = 0
	
	_calculate_next_level()
	
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
	player = self
	
	current_speed = SPEED
	
	add_child(smokeTimer)
	smokeTimer.timeout.connect(_smoke_timeout)
	smokeTimer.the_start(0.2)
	
	add_child(power_timer)
	power_timer.timeout.connect(_power_timeout)
	
	dead.connect(_dead_signal)

func _physics_process(delta):
	if Global.is_paused():
		return
	
	## HORRIBLE way to do this, but I don't have time
	# #GAMBIARRA
	if $Hit.is_playing():
		invulnerable = true
	else:
		invulnerable = false
	
	if get_global_mouse_position().x < global_position.x:
		if mouse_direction.x > 0:
			changed_x = true
		mouse_direction.x = -1
		bodySprite.flip_h = false
		hoodSprite.flip_h = false
	else:
		if mouse_direction.x < 0:
			changed_x = true
		mouse_direction.x = 1
		bodySprite.flip_h = true
		hoodSprite.flip_h = true
	
	if get_global_mouse_position().y < global_position.y:
		if mouse_direction.y > 0:
			changed_y_body = true
			changed_y_hood = true
		mouse_direction.y = 1
	else:
		if mouse_direction.y < 0:
			changed_y_body = true
			changed_y_hood = true
		mouse_direction.y = -1
	
	## REMOVE THIS LATER
	if Input.is_action_just_pressed("Power") and has_power:
		Camera.shake_camera(30)
		var groupMember = get_tree().get_nodes_in_group("Enemy")
		for n in groupMember:
			n.life = 0
		has_power = false
		power_timer.the_start(power_timer_delay)
	
	if not is_in_knockback_state():
		#direction = Input.get_vector("Move Left", "Move Right", "Move Up", "Move Down")
		direction = Vector2(Input.get_action_strength("Move Right") - Input.get_action_strength("Move Left"), 
			Input.get_action_strength("Move Down") - Input.get_action_strength("Move Up")).normalized()
		
		if direction:
			is_running_backwards = _is_running_backwards(direction)
			
			if smokeTimer.is_stopped():
				smokeTimer.the_start()
			
			if is_running_backwards:
				if "Idle" in hoodAnimation.current_animation:
					_play_hood_change_animation(true, true)
				elif not "BW" in hoodAnimation.current_animation or not hoodAnimation.is_playing():
					_play_hood_running_animation(true)
				elif changed_y_hood:
					changed_y_hood = false
					seconds_from_before = hoodAnimation.current_animation_position
					_play_hood_running_animation(true)
					hoodAnimation.seek(seconds_from_before, true)
			elif "Idle" in hoodAnimation.current_animation:
				_play_hood_change_animation(true)
			elif "BW" in hoodAnimation.current_animation or not hoodAnimation.is_playing():
				_play_hood_running_animation()
			elif changed_y_hood:
					changed_y_hood = false
					seconds_from_before = hoodAnimation.current_animation_position
					_play_hood_running_animation()
					hoodAnimation.seek(seconds_from_before, true)
			
			if is_running_backwards:
				if bodyAnimation.speed_scale >= 0:
					bodyAnimation.speed_scale = -1
					seconds_from_before = bodyAnimation.current_animation_position
					_play_body_running_animation()
					bodyAnimation.seek(seconds_from_before, true)
				elif not bodyAnimation.is_playing():
					_play_body_running_animation()
					## For some reason, I need to round it
					bodyAnimation.seek(Global.round_place(
					bodyAnimation.current_animation_length, 3), true)
				elif changed_y_body:
					changed_y_body = false
					seconds_from_before = bodyAnimation.current_animation_position
					_play_body_running_animation()
					bodyAnimation.seek(seconds_from_before, true)
				
			elif not bodyAnimation.is_playing() or "Idle" in bodyAnimation.current_animation:
				bodyAnimation.speed_scale = 1
				_play_body_running_animation()
			elif changed_y_body:
				bodyAnimation.speed_scale = 1
				changed_y_body = false
				seconds_from_before = bodyAnimation.current_animation_position
				_play_body_running_animation()
				bodyAnimation.seek(seconds_from_before, true)
			
			#velocity = direction * current_speed * speed_modifier
		
		else:
		
			if not smokeTimer.is_stopped():
				smokeTimer.stop()
			bodyAnimation.speed_scale = 0.5
			if not hoodAnimation.is_playing():
				_play_hood_idle_animation()
			elif not "Idle" in hoodAnimation.current_animation and (
				not "Stop" in hoodAnimation.current_animation):
				_play_hood_change_animation(false, is_running_backwards)
			if not bodyAnimation.is_playing():
				_play_body_idle_animation()
			if changed_y_body:
				changed_y_body = false
				seconds_from_before = bodyAnimation.current_animation_position
				_play_body_idle_animation()
				bodyAnimation.seek(seconds_from_before, true)
				
			if changed_y_hood:
				changed_y_hood = false
				seconds_from_before = hoodAnimation.current_animation_position
				_play_hood_idle_animation()
				hoodAnimation.seek(seconds_from_before, true)
			
			#velocity.x = move_toward(velocity.x, 0, current_speed * speed_modifier)
			#velocity.y = move_toward(velocity.y, 0, current_speed * speed_modifier)
		velocity = lerp(velocity, direction * current_speed * speed_modifier, delta * accel)
	else:
		velocity = lerp(velocity, knockbackDirection * knockbackForce * current_speed * 1.25, delta * accel)
	
	velocity *= Global.get_player_time_speed()

	hoodSprite.global_position = hoodMarker.global_position

	move_and_slide()

func _is_running_backwards(direction : Vector2) -> bool:
	#return (direction.x < 0 and mouse_direction.x > 0) or (direction.x > 0 and mouse_direction.x < 0
		#) or (direction.y > 0 and mouse_direction.y > 0) or (direction.y < 0 and mouse_direction.y < 0)
	return ((direction.x < 0 and mouse_direction.x > 0) or (direction.x > 0 and mouse_direction.x < 0
		) or (direction.x == 0 and ((direction.y > 0 and mouse_direction.y > 0) or (
		direction.y < 0 and mouse_direction.y < 0))))

func _play_body_idle_animation():
	if mouse_direction.y < 0:
		bodyAnimation.play("Idle Front")
	else:
		bodyAnimation.play("Idle Back")

func _play_body_running_animation():
	if mouse_direction.y < 0:
		bodyAnimation.play("Running Front")
	else:
		bodyAnimation.play("Running Back")

func _play_hood_idle_animation():
	if mouse_direction.y < 0:
		hoodAnimation.play("Idle Front")
	else:
		hoodAnimation.play("Idle Back")

func _play_hood_change_animation(starting : bool, backwards : bool = false):
	if starting:
		if not backwards:
			if mouse_direction.y < 0:
				hoodAnimation.play("Start Running Front")
			else:
				hoodAnimation.play("Start Running Back")
		else:
			if mouse_direction.y < 0:
				hoodAnimation.play("Start Running Front BW")
			else:
				hoodAnimation.play("Start Running Back BW")
	else:
		if not backwards:
			if mouse_direction.y < 0:
				hoodAnimation.play("Stop Running Front")
			else:
				hoodAnimation.play("Stop Running Back")
		else:
			if mouse_direction.y < 0:
				hoodAnimation.play("Stop Running Front BW")
			else:
				hoodAnimation.play("Stop Running Back BW")

func _play_hood_running_animation(backwards : bool = false):
	if not backwards:
		if mouse_direction.y < 0:
			hoodAnimation.play("Running Front")
		else:
			hoodAnimation.play("Running Back")
	else:
		if mouse_direction.y < 0:
			hoodAnimation.play("Running Front BW")
		else:
			hoodAnimation.play("Running Back BW")

func _calculate_next_level() -> void:
	## f(x) = 2x^(2) - x + 10 | NORMAL
	## f(x) = 3x^(2) - 4x + 11 OR f(x) = 5x^(2) - 3x + 9 | HARD
	_points_to_level_up = (2 * pow(_x, 2)) - (_x) + (10) ## NORMAL
	_x += 1

func _check_level_up():
	if _experiencePoints >= _points_to_level_up:
		_experiencePoints = roundi(_experiencePoints) - _points_to_level_up
		level += 1
		_level_up()
		_calculate_next_level()
		_check_level_up() ## Returns the same functions until _experiencePoints is less than the _points_to_level_up

func _level_up():
	Upgrades.show_upgrades()
	#print("Leveled up to " + str(level))

func add_experience_points(quantity_of_points : float) -> void:
	_experiencePoints += quantity_of_points * xp_modifier
	_check_level_up()

static func get_experience_points() -> int:
	return _experiencePoints

static func get_points_to_level_up() -> int:
	return _points_to_level_up

static func add_plastic_items(quantity : int) -> void:
	_plastic_items += quantity

static func add_glass_items(quantity : int) -> void:
	_glass_items += quantity

static func add_paper_items(quantity : int) -> void:
	_paper_items += quantity

static func add_metal_items(quantity : int) -> void:
	_metal_items += quantity

static func get_plastic_items() -> int:
	return _plastic_items

static func get_glass_items() -> int:
	return _glass_items

static func get_paper_items() -> int:
	return _paper_items

static func get_metal_items() -> int:
	return _metal_items

func _dead_signal():
	Global.pause(self)
	Global.death = Global._death_scene.instantiate()
	get_tree().current_scene.add_child(Global.death)

func _smoke_timeout():
	var smoke = smokeScene.instantiate()
	smoke.particle.direction = -direction
	smoke.global_position = $Foot.global_position
	get_tree().current_scene.add_child(smoke)

func _power_timeout():
	has_power = true
	power_timer.stop()
