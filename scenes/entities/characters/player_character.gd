class_name PlayerCharacter
extends CharacterBody2D

@export var top_speed: float = 100.0
@export var acceleration: float = 500.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

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
