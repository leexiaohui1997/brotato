extends Resource
class_name UnitStats

## 高级属性缓存，pri 变更后需调用 refresh 重算
var _sec: Dictionary[TraitConfig.TraitSEC, int]

## 基础属性
var pri: Dictionary[TraitConfig.TraitPRI, int]:
	set(value):
		pri = value
		_sec.clear()
## 高级属性
var sec: Dictionary[TraitConfig.TraitSEC, int]:
	get:
		if _sec.is_empty():
			_sec = TraitConfig.pri_to_sec(pri)
		return _sec

## 生命
var health: int:
	get: return sec.get(TraitConfig.TraitSEC.LIF, 0)
## 攻击
var attack: int:
	get: return sec.get(TraitConfig.TraitSEC.ATK, 0)
## 防御
var defense: int:
	get: return sec.get(TraitConfig.TraitSEC.DEF, 0)
## 速度
var speed: float:
	get: return sec.get(TraitConfig.TraitSEC.SPD, 0)
## 反应
var reaction: float:
	get: return sec.get(TraitConfig.TraitSEC.REA, 0) / 100.0
## 命中
var accuracy: float:
	get: return sec.get(TraitConfig.TraitSEC.ACC, 0) / 100.0
## 闪避
var evasion: float:
	get: return sec.get(TraitConfig.TraitSEC.EVA, 0) / 100.0
## 暴击
var critical: float:
	get: return sec.get(TraitConfig.TraitSEC.CRT, 0) / 100.0
## 格挡
var block: float:
	get: return sec.get(TraitConfig.TraitSEC.BLK, 0) / 100.0
## 连击
var combo: float:
	get: return sec.get(TraitConfig.TraitSEC.COM, 0) / 100.0
## 反击:
var counter: float:
	get: return sec.get(TraitConfig.TraitSEC.CTR, 0) / 100.0

func _init() -> void:
	pri = {}
	for key in TraitConfig.TraitPRI.values():
		pri[key] = 0

## 重算高级属性缓存
func refresh() -> void:
	_sec = TraitConfig.pri_to_sec(pri)

static func create() -> UnitStats:
	var stats := UnitStats.new()
	## 随机分配基础属性
	var total := GameConstants.INIT_TRAIT_NUM
	while total > 0:
		for key in TraitConfig.TraitPRI.values():
			var right := mini(total, ceili(GameConstants.INIT_TRAIT_NUM / 5.0))
			var num := randi_range(1, right)
			stats.pri[key] += num
			total -= num
			if total <= 0: break
	stats.refresh()
	return stats
