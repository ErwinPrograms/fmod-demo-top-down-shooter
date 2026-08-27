class_name RevolverReloadParticles
extends CPUParticles2D

var reference_node: Node2D

func _process(_delta: float) -> void:
	if reference_node:
		direction = Vector2.from_angle(reference_node.rotation)

func start_reload(reference: Node2D):
	reference_node = reference
	emitting = true
