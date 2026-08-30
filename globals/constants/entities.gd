class_name Entities
extends Object

enum Projectile {
	BULLET = 1,
	GRENADE = 2
}

enum Enemy {
	BUG = 1
}

static func instantiate_projectile(type: Projectile) -> BaseProjectile:
	var type_preload: Dictionary[Projectile, Resource] = {
		Projectile.BULLET : preload("uid://csrl42tju8jwf"),
		Projectile.GRENADE: preload("uid://dkpvm80p78f4h")
	}
	return type_preload[type].instantiate()

static func instantiate_enemy(type: Enemy) -> BaseEnemy:
	var type_preload: Dictionary[Enemy, Resource] = {
		Enemy.BUG : preload("uid://c2uqqnt6xno72")
	}
	return type_preload[type].instantiate()
