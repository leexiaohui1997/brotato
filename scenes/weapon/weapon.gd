extends Node2D
class_name Weapon

@export var belong: UnitCommon
@export var weapon_id: WeaponConfig.WeaponId
@onready var sprite: Sprite2D = $Sprite2D

var locked_target: UnitCommon

## 攻击距离
var attack_range: float:
	get: return 300.0

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
	var targets: Array[UnitCommon] = []
	var result: Array = []
	targets.assign(Global.game.entities.find_children("*", "UnitCommon", false, false))
	for item in targets:
		if item == belong: continue
		if belong != Global.game.player and item != Global.game.player: continue
		var distance = belong.global_position.distance_to(item.global_position)
		if distance > attack_range: continue
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

func _ready() -> void:
	sprite.frame = weapon_id

func _process(_delta: float) -> void:
	rotate_to_target()
	update_direction()
