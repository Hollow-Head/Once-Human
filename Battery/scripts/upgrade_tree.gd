extends Control

@onready var text_plastic := $VBoxContainer/GridContainer/Plastic/RichTextLabel
@onready var text_glass := $VBoxContainer/GridContainer/Glass/RichTextLabel
@onready var text_paper := $VBoxContainer/GridContainer/Paper/RichTextLabel
@onready var text_metal := $VBoxContainer/GridContainer/Metal/RichTextLabel

var _initial_scale : Vector2

var maximum : int = 100

var end_scene = preload("res://scenes/end.tscn")

func _ready():
	_initial_scale = scale
	
	global_position = Camera.camera.global_position
	scale = _initial_scale / Camera.camera.zoom
	
	text_plastic.position.y += text_plastic.size.y
	text_glass.position.y += text_glass.size.y
	text_paper.position.y += text_paper.size.y
	text_metal.position.y += text_metal.size.y
	
	if Player.get_plastic_items() < 10:
		text_plastic.text = "00" + str(Player.get_plastic_items()) + "/" + str(maximum)
	elif Player.get_plastic_items() < 100:
		text_plastic.text = "0" + str(Player.get_plastic_items()) + "/" + str(maximum)
	else:
		text_plastic.text = str(Player.get_plastic_items()) + "/" + str(maximum)
	
	if Player.get_glass_items() < 10:
		text_glass.text = "00" + str(Player.get_glass_items()) + "/" + str(maximum)
	elif Player.get_glass_items() < 100:
		text_glass.text = "0" + str(Player.get_glass_items()) + "/" + str(maximum)
	else:
		text_glass.text = str(Player.get_glass_items()) + "/" + str(maximum)
	
	if Player.get_paper_items() < 10:
		text_paper.text = "00" + str(Player.get_paper_items()) + "/" + str(maximum)
	elif Player.get_paper_items() < 100:
		text_paper.text = "0" + str(Player.get_paper_items()) + "/" + str(maximum)
	else:
		text_paper.text = str(Player.get_paper_items()) + "/" + str(maximum)
	
	if Player.get_metal_items() < 10:
		text_metal.text = "00" + str(Player.get_metal_items()) + "/" + str(maximum)
	elif Player.get_metal_items() < 100:
		text_metal.text = "0" + str(Player.get_metal_items()) + "/" + str(maximum)
	else:
		text_metal.text = str(Player.get_metal_items()) + "/" + str(maximum)
	
	if Player.get_plastic_items() >= 100 and Player.get_glass_items() >= 100 and Player.get_paper_items() >= 100 and (
		Player.get_metal_items() >= 100):
		$Save.disabled = false

func _on_plastic_pressed():
	pass

func _on_glass_pressed():
	pass

func _on_paper_pressed():
	pass

func _on_metal_pressed():
	pass

func _on_save_pressed():
	get_tree().change_scene_to_packed(end_scene)
