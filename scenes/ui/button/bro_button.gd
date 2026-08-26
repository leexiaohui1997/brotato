@tool
extends Button
class_name BroButton

@export var config: BroButtonConfig:
	set(value):
		config = value
		update_styles()

func update_styles() -> void:
	if not config:
		return
	var colors := ColorUtils.generate(ColorUtils.COLOR_PRESETS[config.type])
	var border_colors = ColorUtils.generate_border_colors(colors) if config.border_width else null
	var box := StyleBoxFlat.new()
	for key: String in colors.keys():
		var backup := box.duplicate()
		backup.bg_color = colors[key]
		backup.corner_radius_top_left = config.corner_radius
		backup.corner_radius_top_right = config.corner_radius
		backup.corner_radius_bottom_right = config.corner_radius
		backup.corner_radius_bottom_left = config.corner_radius
		if border_colors:
			backup.border_width_left = config.border_width
			backup.border_width_top = config.border_width
			backup.border_width_right = config.border_width
			backup.border_width_bottom = config.border_width
			backup.border_color = border_colors[key]
		add_theme_stylebox_override(key, backup)

func _ready() -> void:
	update_styles()
