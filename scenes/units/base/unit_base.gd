@tool
extends Node2D
class_name UnitBase

@onready var shadow: Sprite2D = %Shadow
@onready var sprite: Sprite2D = %Sprite2D
@onready var anim_player: AnimationPlayer = $AnimationPlayer

@export var config: UnitConfig:
	set(value):
		config = value
		apply_config()

func apply_config() -> void:
	if not is_inside_tree():
		return
	if config == null:
		return
	sprite.frame = config.type
	shadow.visible = config.show_shadow
	anim_player.play(config.animation)

func _ready() -> void:
	apply_config()
