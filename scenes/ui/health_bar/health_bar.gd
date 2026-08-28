extends Control
class_name HealthBar

const HERO_BG = preload("uid://bn3i5y75cufjv")
const HERO_FILL = preload("uid://p4m853syg5p8")

@export var reference: UnitCommon

@onready var progress_bar: ProgressBar = $ProgressBar
@onready var label: Label = $Label

func refresh() -> void:
	if not reference: return
	var denominator = reference.max_health if reference.max_health > 0 else 1
	progress_bar.value = reference.health / float(denominator)
	label.text = str(reference.health)

func _ready() -> void:
	if not reference: return
	refresh()
	reference.on_health_changed.connect(refresh)
	reference.on_max_health_changed.connect(refresh)
	if Global.game and Global.game.player == reference:
		progress_bar.add_theme_stylebox_override("background", HERO_BG)
		progress_bar.add_theme_stylebox_override("fill", HERO_FILL)

func _exit_tree() -> void:
	if not reference: return
	reference.on_health_changed.disconnect(refresh)
	reference.on_max_health_changed.disconnect(refresh)
