extends CharacterBody2D

class_name Entity

@export var life := 0.0
@export var SPEED := 0.0
@export var hurtbox : Area2D
var current_speed : float

## Knockback variables
const _knockbackSpeed := 600.0
const _knockbackDelay := 0.25

var _inKnockbackState : bool
var knockbackDirection : Vector2
var knockbackForce : float
var _knockbackTimer := GlobalTimer.new()

## Signal emited when life is equal or below zero
signal dead

func _init():
	_knockbackTimer.timeout.connect(knockbackTimeout)
	add_child(_knockbackTimer)
	add_to_group("Entity")

func _process(delta):
	if Global.is_paused():
		return
	if life <= 0:
		dead.emit()

func is_in_knockback_state():
	return _inKnockbackState

func receive_damage(body : Node2D, damage : float, direction : Vector2, knockbackForce : float):
	life -= damage
	receive_knockback(direction, knockbackForce)

func receive_knockback(direction : Vector2, knockbackForce : float):
	_inKnockbackState = true
	self.knockbackDirection = direction
	self.knockbackForce = knockbackForce
	if not "Player" in name:
		_knockbackTimer.start(_knockbackTimer.adjusted_time(_knockbackDelay, Global.get_time_speed()))
	else:
		_knockbackTimer.start(_knockbackTimer.adjusted_time(_knockbackDelay, Global.get_player_time_speed()))

func knockbackTimeout() -> void:
	_inKnockbackState = false
	_knockbackTimer.stop()
