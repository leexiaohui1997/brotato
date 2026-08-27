extends Control
class_name UnitDashboard

func toggle_shadow() -> void:
	var units = find_children("*", "UnitBase")
	for item: UnitBase in units:
		var config = item.config.duplicate()
		config.show_shadow = !config.show_shadow
		item.config = config

func toggle_direction() -> void:
	var units = find_children("*", "UnitBase")
	for item: UnitBase in units:
		item.sprite.flip_h = !item.sprite.flip_h

func _on_toggle_shadow_pressed() -> void:
	toggle_shadow()

func _on_toggle_direction_pressed() -> void:
	toggle_direction()
