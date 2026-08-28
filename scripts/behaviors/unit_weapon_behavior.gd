extends Behavior
class_name UnitWeaponBehavior

const WEAPON = preload("uid://dgo6wppwqxv7w")

var weapons: Array[Weapon] = []
var circle_pos := Vector2(0, -UnitBase.UNIT_RADIUS / 2.0)
var circle_radius := UnitBase.UNIT_RADIUS / 1.0

func add_weapon(weapon: Weapon) -> void:
	if weapons.size() >= GameConstants.WEAPON_LIMIT:
		return
	belong.weapons.add_child(weapon)
	weapon.belong = belong
	weapons.append(weapon)
	update_weapon_pos()

func update_weapon_pos() -> void:
	var count := weapons.size()
	belong.weapons.position.y = 0 if count < 3 else -20
	if count == 0: return
	if count == 1:
		weapons[0].position = Vector2(0, circle_pos.y + UnitBase.UNIT_RADIUS / 3.0)
		return
	var step := TAU / count
	for i in count:
		var angle := step * i
		var pos := circle_pos + Vector2.RIGHT.rotated(angle) * circle_radius
		weapons[i].position = pos

## 给武器分配目标
func allocate_targets() -> void:
	var allocated: Array[UnitCommon] = []
	for item in weapons:
		var targets := item.get_targets()
		if targets.is_empty():
			item.release_target()
			continue
		if not targets.has(item.locked_target):
			item.release_target()
			for target in targets:
				if allocated.has(target): continue
				item.locked_target = target
		if not item.locked_target:
			item.locked_target = targets[0]
		allocated.append(item.locked_target)

func _ready() -> void:
	add_weapon(WEAPON.instantiate())
	add_weapon(WEAPON.instantiate())
	add_weapon(WEAPON.instantiate())

func _process(_delta: float) -> void:
	allocate_targets()

func _exit_tree() -> void:
	for item in weapons:
		item.queue_free()
