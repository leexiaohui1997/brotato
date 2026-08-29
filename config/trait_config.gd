class_name TraitConfig

## 基础属性
enum TraitPRI {
	STR, # 力量
	CON, # 体质
	AGI, # 敏捷
	WIS, # 智慧
	LUK, # 运气
}

## 高级属性
enum TraitSEC {
	LIF, # 生命
	ATK, # 攻击
	DEF, # 防御
	SPD, # 速度
	REA, # 反应
	ACC, # 命中
	EVA, # 闪避
	CRT, # 暴击
	BLK, # 格挡
	COM, # 连击
	CTR, # 反击
}

## 初始高级属性
static var secInitial: Dictionary[TraitSEC, int] = {
	TraitSEC.LIF: 100,
	TraitSEC.ATK: 20,
	TraitSEC.SPD: 200,
	TraitSEC.ACC: 100
}

static var TransMap := {
	TraitPRI.STR: {
		TraitSEC.ATK: 10.0,
		TraitSEC.CRT: 2.0,
		TraitSEC.BLK: 1.0,
	},
	TraitPRI.CON: {
		TraitSEC.LIF: 100.0,
		TraitSEC.DEF: 5.0,
		TraitSEC.BLK: 2.0,
		TraitSEC.CTR: 1.0
	},
	TraitPRI.AGI: {
		TraitSEC.SPD: 20.0,
		TraitSEC.REA: 2.0,
		TraitSEC.EVA: 2.0,
		TraitSEC.COM: 2.0,
		TraitSEC.CTR: 1.0
	},
	TraitPRI.WIS: {
		TraitSEC.ATK: 25.0,
		TraitSEC.DEF: 25.0,
		TraitSEC.SPD: 5.0,
		TraitSEC.REA: 1.0,
		TraitSEC.ACC: 1.0,
		TraitSEC.CTR: 2.0
	},
	TraitPRI.LUK: {
		TraitSEC.EVA: 2.0,
		TraitSEC.CRT: 2.0,
		TraitSEC.BLK: 2.0,
		TraitSEC.COM: 2.0,
		TraitSEC.CTR: 2.0
	}
}

## 基础属性换算高级属性
static func pri_to_sec(pri: Dictionary[TraitPRI, int]) -> Dictionary[TraitSEC, int]:
	var sec: Dictionary[TraitSEC, float] = {}
	for key in TraitSEC.values():
		sec.set(key, 0.0 if not secInitial.has(key) else float(secInitial[key]))

	for key_1: TraitPRI in TransMap:
		var num: int = pri[key_1] if pri.has(key_1) else 0
		if num <= 0: continue
		for key_2: TraitSEC in TransMap[key_1]:
			sec[key_2] += num * float(TransMap[key_1][key_2])
	var result: Dictionary[TraitSEC, int] = {}
	for key: TraitSEC in sec:
		result[key] = roundi(sec[key])
	return result
