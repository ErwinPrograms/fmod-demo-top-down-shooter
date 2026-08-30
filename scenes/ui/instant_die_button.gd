extends Button

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		visible = not visible

func _on_pressed() -> void:
	PlayerCharacter.Instance.die()
