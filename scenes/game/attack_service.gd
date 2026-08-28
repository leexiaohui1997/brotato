extends Node
class_name AttackService

@export var game: GameNode

## 触发攻击
func attack(target: UnitCommon, source: Node2D) -> void:
	## 玩家冲刺状态下免伤
	if target == game.player and target.is_dashing: return

	var damage := 0.0
	if source is UnitCommon:
		damage = calculate_unit_damage(source)
	var final_damage := floori(damage)
	if final_damage > 0:
		target.lose_health(final_damage)

## 计算单位伤害
func calculate_unit_damage(source: UnitCommon) -> float:
	return source.attack_power
