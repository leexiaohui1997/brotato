extends Behavior
class_name PlayerBehavior

func _input(evt: InputEvent) -> void:
	if evt.is_action_pressed("dash"):
		belong.dash()

func _process(_delta: float) -> void:
	belong.direction = Input.get_vector("left", "right", "up", "down")
