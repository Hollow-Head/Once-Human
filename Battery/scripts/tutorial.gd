extends Control

@onready var first : NinePatchRect = $First
@onready var second : NinePatchRect = $Second
@onready var third : NinePatchRect = $Third

func _on_left_pressed():
	if second.visible:
		second.visible = false
		first.visible = true
	elif third.visible:
		third.visible = false
		second.visible = true

func _on_right_pressed():
	if second.visible:
		second.visible = false
		third.visible = true
	elif first.visible:
		first.visible = false
		second.visible = true

func _on_leave_pressed():
	Global.change_to_title_screen()
