extends PanelContainer

const AUTOMATION_ONE_NAME: String = "Automation"
const AUTOMATION_TWO_NAME: String = "Health"

func _on_automation_h_slider_value_changed(value: float) -> void:
	FmodSoundtrackEmitter2D.instance.set_parameter(AUTOMATION_ONE_NAME, value)

func _on_automation_2h_slider_value_changed(value: float) -> void:
	FmodSoundtrackEmitter2D.instance.set_parameter(AUTOMATION_TWO_NAME, value)
