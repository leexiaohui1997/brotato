extends Behavior
class_name PlayerBehavior

func update_unit_flip() -> void:
	if not belong.unit_node: return
	var x = belong.direction.x
	if x != 0:
		belong.unit_node.sprite.flip_h = x > 0

func _ready() -> void:
	update_unit_flip()

func _input(evt: InputEvent) -> void:
	if evt.is_action_pressed("dash"):
		belong.dash()

func _process(_delta: float) -> void:
	belong.direction = Input.get_vector("left", "right", "up", "down")
	update_unit_flip()
