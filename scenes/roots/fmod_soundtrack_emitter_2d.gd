extends FmodEventEmitter2D

func _ready() -> void:
	EventBus.enemy_died.connect(_on_enemy_died)
	EventBus.bullet_fired.connect(_on_bullet_fired)

func _on_enemy_died() -> void:
	pass

func _on_bullet_fired() -> void:
	pass
