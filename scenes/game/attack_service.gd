extends Node
class_name AttackService

@export var game: GameNode

## 触发攻击
func attack(target: UnitCommon, source: Node2D) -> void:
	if not source is UnitCommon: return
	var ctx := AttackContext.create(game, target, source)
	if is_immunity(ctx): return
	var final_damage := calculate_damage(ctx)
	if final_damage <= 0: return
	target.lose_health(final_damage)
	game.create_floating_text(target, "-%d" % [final_damage], ColorUtils.ColorType.DAMAGE)

## 判定是否免伤
func is_immunity(ctx: AttackContext) -> bool:
	## 玩家处于冲刺状态时，免疫伤害
	if ctx.target_is_player and ctx.target.is_dashing:
		return true
	return false

## 计算伤害
func calculate_damage(ctx: AttackContext) -> int:
	var damage := 0.0 + ctx.source.attack_power
	return floori(damage)
