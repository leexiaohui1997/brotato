@tool
extends Node2D
class_name UnitBase

const UNIT_RADIUS := 50

@onready var shadow: Sprite2D = %Shadow
@onready var sprite: Sprite2D = %Sprite2D
@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var behaviors: Node = $Behaviors

@export var paused := false
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

func update_position(delta: float) -> void:
	if direction == Vector2.ZERO:
		return
	position += direction * speed * delta
	if Global.game:
		var map = Global.game.map_node
		position.x = clampf(position.x, map.map_start_pos.x, map.map_end_pos.x)
		position.y = clampf(position.y, map.map_start_pos.y, map.map_end_pos.y)

func update_animation() -> void:
	var anim_name = "idle" if direction == Vector2.ZERO else "move"
	if anim_name != anim_player.current_animation:
		anim_player.play(anim_name)

func _ready() -> void:
	apply_config()

func _physics_process(delta: float) -> void:
	if paused:
		return
	update_animation()
	update_position(delta)
