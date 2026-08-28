class_name WeaponConfig

## 武器ID
enum WeaponId {
	PUNCH,
	AXE,
	SWORD,
	CHAINSAW,
	MACE,
	WAND,
	PISTOL,
	LASER,
	SMG,
	SHOTGUN,
	REVOLVER
}

## 武器类型
enum WeaponType {
	MELEE,
	MAGIC,
	REMOTE
}

## 近战武器
var MELEE_WEAPONS: Array[WeaponId] = [
	WeaponId.PUNCH,
	WeaponId.AXE,
	WeaponId.SWORD
]

## 魔法武器
var MAGIC_WEAPONS: Array[WeaponId] = [
	WeaponId.CHAINSAW,
	WeaponId.MACE,
	WeaponId.WAND
]

## 远程武器
var REMOTE_WEAPONS: Array[WeaponId] = [
	WeaponId.PISTOL,
	WeaponId.LASER,
	WeaponId.SMG,
	WeaponId.SHOTGUN,
	WeaponId.REVOLVER
]
