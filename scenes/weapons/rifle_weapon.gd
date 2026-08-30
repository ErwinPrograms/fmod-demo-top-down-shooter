class_name RifleWeapon
extends Node2D

signal ammo_changed(new_ammo: int)

const PROJECTILE = preload("res://scenes/entities/projectiles/rifle_bullet.tscn")

@export var relative_position: Vector2
@export var rounds_per_second: float = 10
@export var reload_time: float = 1.3
@export var ammo_capacity: int = 6
@export var damage: int = 2
@export var disabled: bool = false:
	set(value):
		disabled = value
		visible = not value
		if disabled:
			process_mode = Node.PROCESS_MODE_DISABLED
		else:
			process_mode = Node.PROCESS_MODE_INHERIT

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var fire_rate_timer: Timer = $FireRateTimer
@onready var muzzle_marker: Marker2D = $MuzzleMarker
@onready var shoot_sound_emitter_2d: FmodEventEmitter2D = $ShootSoundEmitter2D
@onready var reload_sound_emitter_2d: FmodEventEmitter2D = $ReloadSoundEmitter2D

var current_ammo: int:
	set(value):
		if current_ammo == value:
			return
		current_ammo = value
		ammo_changed.emit(current_ammo)
		print(current_ammo)
		if shoot_sound_emitter_2d:
			shoot_sound_emitter_2d.set_parameter("Gun shot variants", current_ammo)

func _ready() -> void:
	relative_position = position
	fire_rate_timer.wait_time = (1 / rounds_per_second)
	
	current_ammo = ammo_capacity
	

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		set_rotation_and_position(event.position)
		
func _process(_delta: float) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if current_ammo == 0:
			$EmptyChamberEmitter.play_one_shot()
		fire_rifle()
	if Input.is_action_just_pressed("reload"):
		start_reload()

func set_rotation_and_position(looking_at: Vector2) -> void:
	rotation = global_position.angle_to_point(looking_at)
	
	if abs(rotation) > PI / 2:
		sprite_2d.flip_v = true
		#position.x = -1 * relative_position.x
	else:
		sprite_2d.flip_v = false
		#position.x = relative_position.x

func fire_rifle() -> void:
	if !fire_rate_timer.is_stopped():
		return
	if current_ammo <= 0:
		return
	shoot_sound_emitter_2d.play_one_shot()
	
	
	
	var new_bullet: RifleBullet = PROJECTILE.instantiate()
	new_bullet.damage = damage
	new_bullet.direction = Vector2.from_angle(rotation)
	new_bullet.global_position = muzzle_marker.global_position
	
	get_tree().root.add_child(new_bullet)
	current_ammo -= 1
	
	fire_rate_timer.start()
	EventBus.bullet_fired.emit()

func start_reload() -> void:
	reload_sound_emitter_2d.play_one_shot()
	sprite_2d.rotation = 0
	var reload_tween := get_tree().create_tween()
	reload_tween.tween_property(sprite_2d, "rotation", 3*TAU, reload_time)
	reload_tween.tween_callback(func(): current_ammo = ammo_capacity)
