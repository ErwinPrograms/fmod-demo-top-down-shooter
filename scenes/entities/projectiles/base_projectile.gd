class_name BaseProjectile
extends Area2D

@export var speed: float = 200.0
@export var trail_length: float = 100

var direction: Vector2
var damage: int = 2

@onready var trail_line: Line2D = $TrailLine

func _process(delta: float) -> void:
	if !direction or !direction.is_normalized():
		print("Projectile invalid direction")
	adjust_trail_line(delta)
	
	position += direction * speed * delta

func adjust_trail_line(delta: float) -> void:
	var tail_pos: Vector2 = trail_line.points[0]
	var head_pos: Vector2 = trail_line.points[1] # should always equal 0,0
	if (head_pos - tail_pos).length() < trail_length:
		tail_pos -= direction * speed * delta
		tail_pos = tail_pos.normalized() * min(tail_pos.length(), trail_length)
	trail_line.points = PackedVector2Array([tail_pos, head_pos])

func _on_lifespan_timer_timeout() -> void:
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body is BugEnemy:
		body.take_damage(damage)
		queue_free()
	else:
		print("not type BugEnemy")
