extends Resource
class_name UnitConfig

enum UnitType {
	Grump,
	Pirate,
	Melon,
	Bunny,
	Knight,
	Soldier,
	Skull,
	Devil,
	Sniper,
	Rage
}

enum HeroUnit {
	Grump,
	Pirate,
	Melon,
	Bunny,
	Knight
}

enum EnemyUnit {
	Soldier = UnitType.Soldier,
	Skull,
	Devil,
	Sniper,
	Rage
}

@export var type: UnitType
@export var show_shadow := true
@export_enum("RESET", "idle", "move", "die") var animation := "idle"
