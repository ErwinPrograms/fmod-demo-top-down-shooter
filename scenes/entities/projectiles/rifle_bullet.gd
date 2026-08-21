class_name RifleBullet
extends Area2D

@export var direction: Vector2
@export var speed: float = 200.0
@export var damage: int = 2
#damage
#owner

#range
#starting at
# lifetime

func _process(delta: float) -> void:
	if !direction or !direction.is_normalized():
		print("Projectile invalid direction")
	
	position += direction * speed * delta

func _on_lifespan_timer_timeout() -> void:
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body is BugEnemy:
		body.take_damage(damage)
		queue_free()
	else:
		print("not type BugEnemy")
