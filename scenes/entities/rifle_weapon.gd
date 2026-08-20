class_name RifleWeapon
extends Node2D

const PROJECTILE = preload("res://scenes/entities/projectiles/rifle_bullet.tscn")

@export var relative_position: Vector2
@export var rounds_per_second: float = 10

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var fire_rate_timer: Timer = $FireRateTimer
@onready var muzzle_marker: Marker2D = $MuzzleMarker
@onready var fmod_event_emitter_2d: FmodEventEmitter2D = $FmodEventEmitter2D


func _ready() -> void:
	relative_position = position
	fire_rate_timer.wait_time = (1 / rounds_per_second)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		set_rotation_and_position(event.position)
		
func _process(delta: float) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		fire_rifle()

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
	
	fmod_event_emitter_2d.play_one_shot()
	
	var new_bullet: RifleBullet = PROJECTILE.instantiate()
	new_bullet.direction = Vector2.from_angle(rotation)
	new_bullet.global_position = muzzle_marker.global_position
	
	get_tree().root.add_child(new_bullet)
	
	fire_rate_timer.start()
