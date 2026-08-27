class_name PlayerCharacter
extends CharacterBody2D

@export var top_speed: float = 100.0
@export var acceleration: float = 500.0

static var Instance: PlayerCharacter

var current_weapon: Node2D:
	set(value):
		if value == current_weapon:
			return
		if current_weapon:
			current_weapon.disabled = true
		current_weapon = value
		current_weapon.disabled = false

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var revolver_weapon: RevolverWeapon = $RevolverWeapon
@onready var rifle_weapon: RifleWeapon = $RifleWeapon

func _ready() -> void:
	Instance = self
	current_weapon = rifle_weapon
	revolver_weapon.disabled = true

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("weapon_1"):
		current_weapon = rifle_weapon
	if event.is_action_pressed("weapon_2"):
		current_weapon = revolver_weapon

func _physics_process(delta: float) -> void:

	get_input_change_velocity(delta)
	modify_sprite()
	move_and_slide()

func get_input_change_velocity(delta: float) -> void:
	var input_direction: Vector2 = Input.get_vector("left", "right", "up", "down")
	
	if input_direction == Vector2.ZERO:
		if velocity.length() < 10:
			velocity = Vector2.ZERO
		velocity += acceleration * -velocity.normalized() * delta
	
	velocity += acceleration * input_direction * delta
	if velocity.length() > top_speed:
		velocity = velocity.normalized() * top_speed

func modify_sprite() -> void:
	if velocity != Vector2.ZERO:
		animated_sprite_2d.play("move")
	else:
		animated_sprite_2d.play("idle")
	
	# if velocity.x == 0, don't change sprite flip
	if velocity.x < 0:
		animated_sprite_2d.flip_h = true
	if velocity.x > 0:
		animated_sprite_2d.flip_h = false

func die() -> void:
	$DeathSoundEmitter2D.play_one_shot()
	animated_sprite_2d.rotate(PI / 2)
	modulate = Color.RED
