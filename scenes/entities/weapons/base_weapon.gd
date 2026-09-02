class_name Weapon
extends Node2D

signal ammo_changed(ammo: int)

enum FireType {
	FULL_AUTO = 1,
	BURST = 2,
	SEMI_AUTO = 3,
	BOLT_ACTION = 4,
	PUMP_ACTION = 5,
	WIND_UP = 6,
}

@export_group("Weapon Stats", "weapon_")
@export_range(1, 10, 1, "or_greater") var weapon_damage: int = 1
@export_range(0.1, 20, 0.1, "or_greater", "suffix:/second") var weapon_fire_rate: float = 1.0
@export_range(0.01, 8, 0.1, "or_greater", "suffix:seconds") var weapon_reload_time: float = 1.0
@export_range(1, 200, 1, "or_greater", "suffix:rounds") var weapon_ammo_capacity: int = 6
@export var weapon_projectile_type: Entities.Projectile = Entities.Projectile.BULLET
@export var weapon_fire_type: FireType = FireType.FULL_AUTO

var current_ammo: int:
	set(value):
		if current_ammo == value:
			return
		current_ammo = value
		ammo_changed.emit(current_ammo)
		if shoot_emitter:
			shoot_emitter.set_parameter("Gun shot variants", current_ammo)
var reload_tween: Tween
var equipped: bool = false:
	set(value):
		equipped = value
		visible = equipped
		set_process(equipped)

@onready var shoot_emitter: FmodEventEmitter2D = $ShootEmitter
@onready var reload_emitter: FmodEventEmitter2D = $ReloadEmitter
@onready var empty_chamber_emitter: FmodEventEmitter2D = $EmptyChamberEmitter
@onready var fire_rate_timer: Timer = $FireRateTimer
@onready var sprite: Sprite2D = $Sprite
@onready var muzzle_marker: Marker2D = $MuzzleMarker

@onready var animatedsprite: AnimatedSprite2D = $AnimatedSprite2D
#@onready var revolveranimsprite: AnimatedSprite2D = $AnimatedSprite2D2

func _ready() -> void:
	fire_rate_timer.wait_time = 1 / weapon_fire_rate
	current_ammo = weapon_ammo_capacity
	equipped = false

func _process(_delta: float) -> void:
	_handle_fire_input()
	_point_to_cursor()

func _unhandled_input(event: InputEvent) -> void:
	if not equipped:
		return
	
	if event.is_action_pressed("reload") and (not reload_tween or not reload_tween.is_running()):
		reload()

func _handle_fire_input() -> void:
	if Input.is_action_pressed("fire"):
		if current_ammo == 0:
			if Input.is_action_just_pressed("fire"):
				empty_chamber_emitter.play_one_shot()
			return
		if weapon_fire_type == FireType.FULL_AUTO:
			fire()
		if weapon_fire_type == FireType.SEMI_AUTO and Input.is_action_just_pressed("fire"):
			fire()

func _point_to_cursor() -> void:
	var to: Vector2 = get_global_mouse_position()
	rotation = (to - global_position).angle()
	if abs(rotation) > PI / 2:
		
		sprite.flip_v = true
		animatedsprite.flip_v = true
		
	else:
		sprite.flip_v = false
		animatedsprite.flip_v = false
		

func fire() -> void:
	if not fire_rate_timer.is_stopped():
		return
	
	var new_projectile: BaseProjectile = Entities.instantiate_projectile(weapon_projectile_type)
	var projectile_parent: Node = get_tree().get_first_node_in_group("projectile_container")
	projectile_parent.add_child(new_projectile)
	new_projectile.damage = weapon_damage
	new_projectile.direction = Vector2.from_angle(rotation)
	new_projectile.global_position = muzzle_marker.global_position
	
	current_ammo -= 1
	shoot_emitter.play_one_shot()
	
	fire_rate_timer.start()

func reload() -> void:
	# Play sound
	reload_emitter.play_one_shot()
	
	# Tween animationsar
	if reload_tween:
		reload_tween.kill()
	reload_tween = create_tween()
	sprite.rotation = 0
	#reload_tween.tween_property(sprite, "rotation", 3*TAU, weapon_reload_time)
	reload_tween.tween_callback(func(): current_ammo = weapon_ammo_capacity)
