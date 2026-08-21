extends FmodEventEmitter2D

var num_enemies: int = 6 # hardcoded based off GameWorld scene
var bullets_fired: int = 0

func _ready() -> void:
	EventBus.enemy_died.connect(_on_enemy_died)
	EventBus.bullet_fired.connect(_on_bullet_fired)

func _on_enemy_died() -> void:
	num_enemies -= 1
	
	if num_enemies == 0:
		# Do something because no enemies
		self.stop()
		pass

func _on_bullet_fired() -> void:
	bullets_fired += 1
	var max_intensity: int = 50
	var flanger: float = lerp(0, 100, bullets_fired / max_intensity)
	
	set_parameter("Flanger 2", flanger)
