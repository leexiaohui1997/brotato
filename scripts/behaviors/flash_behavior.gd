extends Behavior
class_name FlashBehavior

const FLASH = preload("uid://d0egsxax21dqp")

var flash_material: ShaderMaterial

func start_flash(_lose: int) -> void:
	if not flash_material: return
	if belong.unit_node.sprite.material: return
	belong.unit_node.sprite.material = flash_material
	await get_tree().create_timer(0.2).timeout
	if not is_instance_valid(belong) or not is_instance_valid(belong.unit_node): return
	if is_instance_valid(belong.unit_node.sprite):
		belong.unit_node.sprite.material = null

func _ready() -> void:
	flash_material = ShaderMaterial.new()
	flash_material.shader = FLASH
	belong.on_damaged.connect(start_flash)

func _exit_tree() -> void:
	belong.on_damaged.disconnect(start_flash)
