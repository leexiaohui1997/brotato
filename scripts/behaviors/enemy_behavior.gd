extends Behavior
class_name EnemyBehavior

## 推力影响范围
const THRUST_DISTANCE := UnitBase.UNIT_RADIUS * 2.0
## 推力系数
const THRUST_STRENGTH := UnitBase.UNIT_RADIUS

## 攻击冷却时间
var attack_cooldown: float:
	get: return GameConstants.ENEMY_ATTACK_COOLDOWN
var can_attack := true

## 是否可以追击玩家
func can_chase_player() -> bool:
	if not player: return false
	return belong.global_position.distance_to(player.global_position) > UnitBase.UNIT_RADIUS

## 获取追击玩家的方向
func get_chase_direction() -> Vector2:
	if not can_chase_player(): return Vector2.ZERO
	return belong.global_position.direction_to(player.global_position)

## 叠加其它敌人赋予的推力
func apply_thrust(direction: Vector2) -> Vector2:
	if not game: return direction
	if not game.entities: return direction
	if direction == Vector2.ZERO: return direction
	var units = game.entities.find_children("*", "UnitCommon", false, false)
	for item: UnitCommon in units:
		if item == belong or item == player:
			continue
		var pos_1 := item.global_position
		var pos_2 := belong.global_position
		if pos_1.distance_to(pos_2) > THRUST_DISTANCE:
			continue
		var vec := pos_2 - pos_1
		direction += THRUST_STRENGTH * vec.normalized() / vec.length()
	return direction

## 更新朝向
func update_unit_flip() -> void:
	if not player: return
	if not belong.unit_node: return
	belong.unit_node.sprite.flip_h = belong.global_position.x < player.global_position.x

## 攻击玩家
func attack_player() -> void:
	if not player: return
	if not can_attack: return
	if belong.global_position.distance_to(player.global_position) <= UnitBase.UNIT_RADIUS:
		can_attack = false
		game.attack_service.attack(player, belong)
		await get_tree().create_timer(attack_cooldown).timeout
		can_attack = true

func _ready() -> void:
	update_unit_flip()

func _physics_process(_delta: float) -> void:
	belong.direction = apply_thrust(get_chase_direction())
	update_unit_flip()
	attack_player()
