class_name BugEnemy
extends CharacterBody2D

var health: int = 3
var dead: bool = false

func take_damage(damage: int) -> void:
	health -= damage
	
	if health <= 0:
		die()

func die() -> void:
	# show death animation
	# trigger died signal
	# leave corpse/linger
	# disconnect from signals, remove hitbox
	# automatically remove after some time
	
	if dead:
		return
	#placeholder queue free
	dead = true
	$FmodEventEmitter2D.play_one_shot()
	EventBus.enemy_died.emit()
	await get_tree().create_timer(1).timeout
	queue_free()
	
	
