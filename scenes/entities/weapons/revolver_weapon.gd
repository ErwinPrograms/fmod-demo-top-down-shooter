extends Weapon

const REVOLVER_RELOAD_PARTICLES = preload("uid://ddggk562ii7e5")

func reload() -> void:
	super.reload()
	
	var particle_container: Node = get_tree().get_first_node_in_group("projectile_container")
	var new_particles: CPUParticles2D = REVOLVER_RELOAD_PARTICLES.instantiate()
	sprite.add_child(new_particles)
	new_particles.emitting = true
	
	await get_tree().create_timer(0.3).timeout
	new_particles.reparent(particle_container)
