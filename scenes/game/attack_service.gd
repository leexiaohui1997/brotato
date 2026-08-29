extends Node
class_name AttackService

@export var game: GameNode

## 触发攻击
func attack(target: UnitCommon, source: Node2D) -> void:
	if not source is UnitCommon: return
	var ctx := AttackContext.create(game, target, source)
	execute_ctx(ctx)

## 延迟连锁攻击前校验相关节点是否仍然有效且存活
func _can_chain(target: UnitCommon, source: UnitCommon) -> bool:
	return (
		is_instance_valid(self)
		and is_instance_valid(game)
		and is_instance_valid(target)
		and is_instance_valid(source)
		and not target.is_died
		and not source.is_died
	)

## 执行攻击逻辑
func execute_ctx(ctx: AttackContext) -> void:
	var target := ctx.target
	var source := ctx.source
	## 防止攻击
	if ctx.is_prevent: return
	## 触发闪避
	if ctx.is_evasion:
		game.create_floating_text(target, "闪避", ColorUtils.ColorType.EPIC)
		return
	## 触发格挡
	if ctx.is_blocked:
		game.create_floating_text(target, "格挡", ColorUtils.ColorType.BLOCKED)
	## 最终伤害
	if ctx.damage <= 0: return
	var color := (
		ColorUtils.ColorType.CRITICAL
		if ctx.is_critical
		else ColorUtils.ColorType.DAMAGE
	)
	target.lose_health(ctx.damage)
	game.create_floating_text(target, "-%d" % [ctx.damage], color)
	## 连击
	if ctx.is_combo:
		get_tree().create_timer(0.1).timeout.connect(func():
			if not is_inside_tree(): return
			if not _can_chain(target, source): return
			game.create_floating_text(source, "连击", ColorUtils.ColorType.EPIC)
			var combo_ctx := AttackContext.create(
				ctx.game,
				target,
				source,
				ctx
			)
			execute_ctx(combo_ctx)
		)
	## 反击
	if ctx.is_counter:
		get_tree().create_timer(0.1).timeout.connect(func():
			if not is_inside_tree(): return
			if not _can_chain(target, source): return
			game.create_floating_text(target, "反击", ColorUtils.ColorType.EPIC)
			var counter_ctx := AttackContext.create(
				ctx.game,
				source,
				target,
				ctx
			)
			execute_ctx(counter_ctx)
		)
