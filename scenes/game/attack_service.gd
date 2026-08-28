extends Node
class_name AttackService

@export var game: GameNode

## 触发攻击
func attack(target: UnitCommon, source: Node2D) -> void:
	if not source is UnitCommon: return
	var ctx := AttackContext.create(game, target, source)
	## 防止攻击
	if ctx.is_prevent: return
	
	## 触发格挡
	if ctx.is_blocked:
		game.create_floating_text(target, "格挡", ColorUtils.ColorType.BLOCKED)
		return

	## 最终伤害
	if ctx.damage <= 0: return
	target.lose_health(ctx.damage)
	game.create_floating_text(target, "-%d" % [ctx.damage], ColorUtils.ColorType.DAMAGE)
