extends Control

var _initial_scale : Vector2

func _ready():
	_initial_scale = scale

func _process(delta):
	global_position = Camera.camera.global_position
	scale = _initial_scale / Camera.camera.zoom

func _on_retomar_pressed():
	Global.resume()
	queue_free()

func _on_opcoes_pressed():
	pass

func _on_voltar_pressed():
	Global.resume()
	Global.change_to_title_screen()
