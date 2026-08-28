class_name AttackContext

var game: GameNode
var target: UnitCommon
var source: UnitCommon

## 是否防止
var is_prevent: bool
## 是否触发格挡
var is_blocked: bool
## 最终伤害
var damage: int

## 攻击对象是否为玩家
var target_is_player: bool:
	get: return game and game.player == target

## 攻击来源是否为玩家
var source_is_player: bool:
	get: return game and game.player == source

static func create(
	_game: GameNode,
	_target: UnitCommon,
	_source: UnitCommon
) -> AttackContext:
	var ctx := AttackContext.new()
	ctx.game = _game
	ctx.target = _target
	ctx.source = _source
	ctx.setup()
	return ctx

var calculates: Array[Callable] = [
	calculate_prevent,
	calculate_blocked,
	calculate_damage,
]

## 计算防止
func calculate_prevent() -> bool:
	if target_is_player and target.is_dashing:
		is_prevent = true
	return is_prevent

## 计算格挡
func calculate_blocked() -> bool:
	return is_blocked

## 计算最终伤害
func calculate_damage() -> void:
	damage = source.attack_power

func setup() -> void:
	for item in calculates:
		if item.call(): return
