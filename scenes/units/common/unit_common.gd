extends Node2D
class_name UnitCommon

signal on_dash_start
signal on_health_changed
signal on_max_health_changed
signal on_damaged(lose: int)
signal on_died

const UNIT_BASE = preload("uid://c1l18o0sk0hw1")

@export var stats: UnitStats = UnitStats.new()
@export var config: UnitConfig

@onready var behaviors: Node = $Behaviors
@onready var dash_timer: Timer = %DashTimer
@onready var dash_cooldown_timer: Timer = %DashCooldownTimer
@onready var weapons: Node2D = $Weapons

var unit_node: UnitBase

var direction: Vector2

var can_dash: bool:
	get: return false if not dash_cooldown_timer else dash_cooldown_timer.is_stopped()
var is_dashing: bool:
	get: return false if not dash_timer else !dash_timer.is_stopped()

## 移动速度
var speed: float:
	get:
		var s := stats.speed
		if is_dashing:
			s *= GameConstants.DASH_SPEED_MULTI
		return s

## 当前生命
var health: int = 10:
	set(value):
		health = value
		on_health_changed.emit()
		if health <= 0: die()

## 生命上限
var max_health: int = 10:
	set(value):
		max_health = value
		on_max_health_changed.emit()

## 是否已死亡
var is_died: bool:
	get: return health <= 0

## 是否朝向右侧
var is_facing_right: bool:
	get: return unit_node and unit_node.sprite and unit_node.sprite.flip_h

## 扣血
func lose_health(amount: int) -> void:
	if amount == 0: return
	if health <= 0: return
	var old_health := health
	var new_health := clampi(health - amount, 0, max_health)
	var lose := old_health - new_health
	health = new_health
	on_damaged.emit(lose)

## 死亡逻辑
func die() -> void:
	unit_node.anim_player.play("die")
	await unit_node.anim_player.animation_finished
	on_died.emit()
	queue_free()

func create_unit() -> void:
	if unit_node: return
	unit_node = UNIT_BASE.instantiate()
	unit_node.config = config
	unit_node.name = "UnitBase"
	add_child(unit_node)

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

func dash() -> void:
	if not can_dash: return
	if is_dashing: return
	if direction == Vector2.ZERO: return
	dash_timer.start()
	on_dash_start.emit()

func _ready() -> void:
	create_unit()
	dash_timer.wait_time = GameConstants.DASH_DURATION
	dash_cooldown_timer.wait_time = GameConstants.DASH_COOLDOWN
	max_health = stats.health
	health = max_health

func _physics_process(delta: float) -> void:
	if is_died: return
	update_animation()
	update_position(delta)

func _on_dash_timer_timeout() -> void:
	dash_cooldown_timer.start()
