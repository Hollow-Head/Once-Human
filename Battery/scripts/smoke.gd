extends Node2D

var backwards : bool

func _process(delta):
	if backwards:
		$Sprite2D.flip_h = true
	else:
		$Sprite2D.flip_h = false
	if not $Sprite2D/AnimationPlayer.is_playing():
		queue_free()
