class_name RevolverWeapon
extends Weapon

const REVOLVER_RELOAD_PARTICLES = preload("uid://ddggk562ii7e5")

#var sprite: AnimatedSprite2D2 = $AnimatedSprite2D2

#@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func reload() -> void:
	super.reload()
	
	$AnimationPlayer2.stop()
	$AnimationPlayer2.play("reload")
	
	
	var particle_container: Node = get_tree().get_first_node_in_group("projectile_container")
	var new_particles: CPUParticles2D = REVOLVER_RELOAD_PARTICLES.instantiate()
	sprite.add_child(new_particles)
	new_particles.emitting = true
	
	await get_tree().create_timer(0.3).timeout
	new_particles.reparent(particle_container)

func fire() -> void:
	super.fire()
	$AnimationPlayer2.stop()
	$AnimationPlayer2.play("fire")
	
