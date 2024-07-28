extends Area2D

class_name Item

@export var autoPickable : bool

signal pick_up

func _init():
	connect("body_entered", _body_entered)
	add_to_group("Item")

func _body_entered(body : Node2D):
	if "Player" in body.name:
		if autoPickable:
			pick_up.emit()
		elif Input.is_action_just_pressed("Pick Up"):
			pick_up.emit()
