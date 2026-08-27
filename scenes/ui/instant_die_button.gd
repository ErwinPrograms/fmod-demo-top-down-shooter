extends Button


func _on_pressed() -> void:
	PlayerCharacter.Instance.die()
