extends Node2D
class_name Weapon

const WEAPON = preload("uid://dgo6wppwqxv7w")

static func create() -> Weapon:
	var weapon := WEAPON.instantiate() as Weapon
	return weapon

var belong: UnitCommon
var weapon_id: WeaponConfig.WeaponId
var stats: WeaponStats

@onready var sprite: Sprite2D = $Sprite2D
@onready var behaviors: Node = $Behaviors

## 是否是近战武器
var is_melee: bool:
	get: return WeaponConfig.MELEE_WEAPONS.has(weapon_id)
## 是否是远程武器
var is_remote: bool:
	get: return WeaponConfig.REMOTE_WEAPONS.has(weapon_id)

var locked_target: UnitCommon
var is_attacking := false
var is_frozen := false

func get_idle_rotation() -> float:
	if not belong: return 0
	if belong.is_facing_right: return 0
	return PI

func rotate_to_target() -> void:
	if not belong: return
	if locked_target:
		rotation = global_position.direction_to(locked_target.global_position).angle()
	else:
		rotation = get_idle_rotation()

## 获取攻击距离内的目标
func get_targets() -> Array[UnitCommon]:
	if not belong: return []
	if not Global.game: return []
	var targets := Global.game.get_enemies(belong)
	var result: Array = []
	for item in targets:
		var distance = belong.global_position.distance_to(item.global_position)
		if distance > stats.attack_range: continue
		result.append([distance, item])
	result.sort_custom(func(a: Array, b: Array): return a[0] - b[0])
	return result.reduce(func(acc: Array, item: Array):
		acc.append(item[1])
		return acc
	, [] as Array[UnitCommon])

## 释放目标
func release_target() -> void:
	locked_target = null

func update_direction() -> void:
	sprite.flip_v = abs(rotation) > PI / 2

func add_behavior(behavior: WeaponBehavior) -> void:
	behavior.belong = self
	behaviors.add_child(behavior)

func _init() -> void:
	stats = WeaponStats.new()

func _ready() -> void:
	sprite.frame = weapon_id
	if is_melee:
		add_behavior(MeleeWeaponBehavior.new())

func _process(_delta: float) -> void:
	if not is_instance_valid(locked_target):
		release_target()
	rotate_to_target()
	update_direction()
