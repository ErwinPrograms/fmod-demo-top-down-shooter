class_name Grenade
extends BaseProjectile

var explosion_damage: int = 3

@onready var explosion_radius: Area2D = $ExplosionRadius

func _process(delta: float) -> void:
	super(delta)
	
	$Sprite2D.rotation = direction.angle()

func _on_body_entered(body: Node2D) -> void:
	super(body)
	
	var enemies_in_radius: Array[Node2D] = explosion_radius.get_overlapping_bodies()
	for enemy in enemies_in_radius:
		if enemy is BaseEnemy:
			enemy.take_damage(explosion_damage)
