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
static var MELEE_WEAPONS: Array[WeaponId] = [
	WeaponId.PUNCH,
	WeaponId.AXE,
	WeaponId.SWORD,
	WeaponId.CHAINSAW,
	WeaponId.MACE,
	WeaponId.WAND
]

## 远程武器
static var REMOTE_WEAPONS: Array[WeaponId] = [
	WeaponId.PISTOL,
	WeaponId.LASER,
	WeaponId.SMG,
	WeaponId.SHOTGUN,
	WeaponId.REVOLVER
]
