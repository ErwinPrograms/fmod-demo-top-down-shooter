extends Node2D

const BUG_ENEMY = preload("uid://c2uqqnt6xno72")
const LEFT_BOUNDRY: float = 0.0
const RIGHT_BOUNDRY: float = 320.0
const UP_BOUNDRY: float = 0.0
const DOWN_BOUNDRY: float = 180.0

@export var respawn_time: float = 1.
@export var enemies_per_wave: int = 2
@export var active: bool = true

var _time_since_last_wave: float = 0

func _process(delta: float) -> void:
	if not active:
		return
	
	_time_since_last_wave += delta
	
	if _time_since_last_wave >= respawn_time:
		spawn_enemies()
		_time_since_last_wave = 0

func spawn_enemies() -> void:
	for i in range(enemies_per_wave):
		var left_spawn_point := Vector2(-20, randf_range(UP_BOUNDRY, DOWN_BOUNDRY))
		var new_bug: BugEnemy = BUG_ENEMY.instantiate()
		new_bug.position = left_spawn_point
		get_parent().add_child(new_bug)
