extends Node2D
class_name UnitCommon

const UNIT_BASE = preload("uid://c1l18o0sk0hw1")

@export var stats: UnitStats = UnitStats.new()
@export var config: UnitConfig

@onready var behaviors: Node = $Behaviors
var unit_node: UnitBase

var direction: Vector2:
	set(value):
		direction = value
		update_unit_flip()

var speed: float:
	get:
		return stats.speed

func update_unit_flip() -> void:
	if not unit_node: return
	if direction.x != 0:
		unit_node.sprite.flip_h = direction.x > 0

func create_unit() -> void:
	if unit_node: return
	unit_node = UNIT_BASE.instantiate()
	unit_node.config = config
	unit_node.name = "UnitBase"
	add_child(unit_node)
	update_unit_flip()

func add_behavior(node: Behavior) -> void:
	node.belong = self
	behaviors.add_child(node)

func update_position(delta: float) -> void:
	if direction == Vector2.ZERO:
		return
	position += direction * speed * delta
	if Global.game:
		var map = Global.game.map_node
		position.x = clampf(position.x, map.map_start_pos.x, map.map_end_pos.x)
		position.y = clampf(position.y, map.map_start_pos.y, map.map_end_pos.y)

func update_animation() -> void:
	if not unit_node: return
	var anim_player = unit_node.anim_player
	var anim_name = "idle" if direction == Vector2.ZERO else "move"
	if anim_name != anim_player.current_animation:
		anim_player.play(anim_name)

func _ready() -> void:
	create_unit()

func _physics_process(delta: float) -> void:
	update_animation()
	update_position(delta)
