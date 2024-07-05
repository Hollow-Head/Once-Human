extends CharacterBody2D

class_name Entity

@export var life : float

signal dead

func _init():
	add_to_group("Entity")

func _process(delta):
	if life <= 0:
		dead.emit()

func receive_damage(body : Node2D, damage : float, knockbackForce : float):
	life -= damage
