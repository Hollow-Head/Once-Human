extends Control

func _process(delta):
	$ColorRect.size = get_viewport_rect().size

func _on_jogar_pressed():
	Global.change_to_game_screen()

func _on_opcoes_pressed():
	get_tree().change_scene_to_packed(Global._tutorial_scene)

func _on_sair_pressed():
	get_tree().quit()
