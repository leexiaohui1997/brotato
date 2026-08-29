extends WeaponBehavior
class_name MeleeWeaponBehavior

var can_damage := false
var damaged_targets: Array[UnitCommon] = []

func attack() -> void:
	if not belong: return
	if not belong.locked_target: return
	if belong.is_attacking: return
	if belong.is_frozen: return
	belong.is_attacking = true
	var start_pos := belong.sprite.position
	var target_pos := Vector2(start_pos.x + belong.stats.attack_range, start_pos.y)
	var recoil_pos := Vector2(start_pos.x - 15, start_pos.y)
	var tween := create_tween()
	var step_1 := tween.tween_property(belong.sprite, "position", recoil_pos, belong.stats.recoil_duration)
	var step_2 := tween.tween_property(belong.sprite, "position", target_pos, belong.stats.attack_duration)
	var step_3 := tween.tween_property(belong.sprite, "position", start_pos, belong.stats.back_duration)
	await step_1.finished
	can_damage = true
	damaged_targets.clear()
	await step_2.finished
	can_damage = false
	damaged_targets.clear()
	await step_3.finished
	if not is_instance_valid(belong): return
	belong.is_attacking = false
	belong.is_frozen = true
	var timer := get_tree().create_timer(belong.stats.cooldown)
	await timer.timeout
	if not is_instance_valid(belong): return
	belong.is_frozen = false

func _process(_delta: float) -> void:
	if not game: return
	attack()
	if not can_damage: return
	var targets := game.get_enemies(belong_unit)
	for item in targets:
		if damaged_targets.has(item): continue
		if belong.sprite.global_position.distance_to(item.global_position) <= UnitBase.UNIT_RADIUS:
			damaged_targets.append(item)
			game.attack_service.attack(item, belong_unit, belong)
