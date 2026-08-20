class_name BugEnemy
extends CharacterBody2D

var health: int = 3

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
	
	#placeholder queue free
	$FmodEventEmitter2D.play_one_shot()
	await $FmodEventEmitter2D.stopped
	queue_free()
