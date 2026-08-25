class_name AmmoLeftLabel
extends RichTextLabel


func _on_rifle_weapon_ammo_changed(new_ammo: int) -> void:
	text = "%s: %d/7" % ["Ammo", new_ammo]
