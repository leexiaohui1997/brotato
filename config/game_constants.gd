class_name GameConstants

## 初始属性点数
static var INIT_TRAIT_NUM: int:
	get: return 10

## 移动速度
static var MOVE_SPEED: float:
	get: return 300.0
## 冲刺时间
static var DASH_DURATION: float:
	get: return 0.5
## 冲刺加速倍率
static var DASH_SPEED_MULTI: float:
	get: return 2.0
## 冲刺冷却时间
static var DASH_COOLDOWN: float:
	get: return 2.0
## 敌人攻击冷却时间
static var ENEMY_ATTACK_COOLDOWN: float:
	get: return 2.0
## 武器数量上限
static var WEAPON_LIMIT: int:
	get: return 6

## 暴击伤害倍率
static var CRITICAL_DAMAGE_MULTI: float:
	get: return 1.5

## 格挡减伤比例
static var BLOCK_DAMAGE_REDUCE: float:
	get: return 0.5
