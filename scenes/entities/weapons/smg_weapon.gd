class_name SMGWeapon
extends Weapon

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func reload() -> void:
	super()
	
	animation_player.play("reload")
