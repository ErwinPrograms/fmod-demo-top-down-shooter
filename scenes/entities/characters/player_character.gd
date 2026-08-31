class_name PlayerCharacter
extends CharacterBody2D

@export var top_speed: float = 100.0
@export var acceleration: float = 500.0

static var Instance: PlayerCharacter

var current_weapon: Weapon:
	set(value):
		if value == current_weapon:
			return
		if current_weapon:
			current_weapon.equipped = false
		current_weapon = value
		current_weapon.equipped = true
var weapons: Array[Weapon]

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	Instance = self
	var weapon_group = get_tree().get_nodes_in_group("weapon")
	weapons = []
	weapons.assign(weapon_group.filter(func(item): return item is Weapon))
	current_weapon = weapons[0]

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("weapon_1") and weapons[0]:
		current_weapon = weapons[0]
	if event.is_action_pressed("weapon_2") and weapons[1]:
		current_weapon = weapons[1]
	if event.is_action_pressed("weapon_3") and weapons[2]:
		current_weapon = weapons[2]
	if event.is_action_pressed("weapon_4") and weapons[3]:
		current_weapon = weapons[3]
	

func _physics_process(delta: float) -> void:
	get_input_change_velocity(delta)
	apply_velocity_damping(delta)
	modify_sprite()
	move_and_slide()

func get_input_change_velocity(delta: float) -> void:
	var input_direction: Vector2 = Input.get_vector("left", "right", "up", "down")
	
	if input_direction == Vector2.ZERO:
		if velocity.length() < 10:
			velocity = Vector2.ZERO
		velocity += acceleration * -velocity.normalized() * delta
	
	velocity += acceleration * input_direction * delta

func apply_velocity_damping(delta: float) -> void:
	if velocity.length() > top_speed:
		velocity = velocity.move_toward(velocity.normalized() * top_speed, acceleration * delta)

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
