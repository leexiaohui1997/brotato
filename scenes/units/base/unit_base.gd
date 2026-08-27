@tool
extends Node2D
class_name UnitBase

@onready var shadow: Sprite2D = %Shadow
@onready var sprite: Sprite2D = %Sprite2D
@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var behaviors: Node = $Behaviors

@export var config: UnitConfig:
	set(value):
		config = value
		apply_config()

var direction: Vector2:
	set(value):
		direction = value
		if direction.x != 0:
			sprite.flip_h = direction.x > 0

var speed: float:
	get:
		return 200

func add_behavior(node: Behavior) -> void:
	node.belong = self
	behaviors.add_child(node)

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

func _physics_process(delta: float) -> void:
	if direction != Vector2.ZERO:
		position += direction * speed * delta
