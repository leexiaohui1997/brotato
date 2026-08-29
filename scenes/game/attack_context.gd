class_name AttackContext

var game: GameNode
var target: UnitCommon
var source: UnitCommon

## 上一次攻击
var last_attack: AttackContext

## 是否防止
var is_prevent: bool
## 是否触发格挡
var is_blocked: bool
## 是否触发闪避
var is_evasion: bool
## 是否触发暴击
var is_critical: bool
## 是否触发连击
var is_combo: bool
## 是否触发反击
var is_counter: bool
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
	_source: UnitCommon,
	_last_attack: AttackContext = null
) -> AttackContext:
	var ctx := AttackContext.new()
	ctx.game = _game
	ctx.target = _target
	ctx.source = _source
	ctx.last_attack = _last_attack
	ctx.setup()
	return ctx

var calculates: Array[Callable] = [
	calculate_prevent,
	calculate_evasion,
	calculate_blocked,
	calculate_critical,
	calculate_damage,
	calculate_combo,
	calculate_counter
]

## 计算防止
func calculate_prevent() -> bool:
	if target_is_player and target.is_dashing:
		is_prevent = true
	return is_prevent

## 计算闪避
func calculate_evasion() -> bool:
	var chance := source.stats.accuracy - target.stats.evasion
	if not Helper.get_chance(chance):
		is_evasion = true
	return is_evasion

## 计算格挡
func calculate_blocked() -> void:
	var chance := target.stats.block
	if Helper.get_chance(chance):
		is_blocked = true

## 计算暴击
func calculate_critical() -> void:
	if is_blocked: return
	var chance := source.stats.critical
	if Helper.get_chance(chance):
		is_critical = true

## 计算最终伤害
func calculate_damage() -> void:
	var attack := float(source.stats.attack)
	var defense := float(target.stats.defense)
	var denominator := attack + defense
	## 攻防同时为零时无有效伤害基数，按最小伤害处理
	if denominator <= 0.0:
		damage = 1
		return
	var base_damage := pow(attack, 2) / denominator
	if is_critical:
		base_damage *= GameConstants.CRITICAL_DAMAGE_MULTI
	elif is_blocked:
		base_damage *= 1.0 - GameConstants.BLOCK_DAMAGE_REDUCE
	damage = maxi(roundi(base_damage), 1)

## 计算连击
func calculate_combo() -> void:
	if last_attack: return
	var chance := source.stats.combo
	if Helper.get_chance(chance):
		is_combo = true

## 计算反击
func calculate_counter() -> void:
	## 仅原始攻击可触发反击，避免连击/反击无限反弹
	if last_attack: return
	if is_combo: return
	if is_critical: return
	var chance := target.stats.counter
	if Helper.get_chance(chance):
		is_counter = true

func setup() -> void:
	for item in calculates:
		if item.call(): return
