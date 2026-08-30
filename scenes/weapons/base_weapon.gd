class_name Weapon
extends Node2D

@export_group("Weapon Stats", "weapon_")
@export var weapon_damage: int
@export_range(0.1, 60, 0.1, "or_greater", "suffix:/second") var weapon_fire_rate: float
@export_range(0.01, 8, 0.1, "or_greater", "suffix:seconds") var weapon_reload_time: float
@export_range(1, 200, 1, "or_greater", "suffix:rounds") var weapon_ammo_capacity: int = 6
@export var weapon_projectile_type: Entities.Projectile = Entities.Projectile.BULLET
