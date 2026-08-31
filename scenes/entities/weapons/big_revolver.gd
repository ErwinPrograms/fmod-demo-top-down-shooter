class_name BigRevolver
extends RevolverWeapon

@export var knockback_velocity: float = 1000

func fire() -> void:
	super()
	
	PlayerCharacter.Instance.velocity = Vector2.from_angle(rotation) * -1 * knockback_velocity
