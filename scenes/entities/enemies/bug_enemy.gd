class_name BugEnemy
extends BaseEnemy

const BLOOD_PARTICLES: Resource = preload("uid://6uofx3muwlpl")

@export var move_speed: float = 20.0
@export var health: int = 3

var dead: bool = false
var player: PlayerCharacter

@onready var hit_marker: FmodEventEmitter2D = $HitMarker

func _ready() -> void:
	player = PlayerCharacter.Instance

func _physics_process(delta: float) -> void:
	if dead:
		return
	
	velocity = move_speed * (player.position - position).normalized()
	
	move_and_slide()


func take_damage(damage: int) -> void:
	hit_marker.play_one_shot()
	health -= damage
	
	if health <= 0:
		die()

func die() -> void:
	# show death animation
	# trigger died signal
	# leave corpse/linger
	# disconnect from signals, remove hitbox
	# automatically remove after some time
	
	if dead:
		return
	var particles: CPUParticles2D = BLOOD_PARTICLES.instantiate()
	particles.global_position = position
	get_tree().root.add_child(particles)
	particles.restart()
	
	
	#placeholder queue free
	dead = true
	$FmodEventEmitter2D.play_one_shot()
	EventBus.enemy_died.emit()
	await get_tree().create_timer(0.001).timeout
	queue_free()
