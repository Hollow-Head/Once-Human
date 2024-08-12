extends Node2D

class_name OneShotParticle

@export var particle : CPUParticles2D

func _ready():
	particle.emitting = true
	particle.finished.connect(_particle_finished)
	y_sort_enabled = true
	z_index = -1

func _particle_finished():
	queue_free()
