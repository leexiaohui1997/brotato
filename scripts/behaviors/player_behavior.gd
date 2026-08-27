extends Behavior
class_name PlayerBehavior

func _process(_delta: float) -> void:
	belong.direction = Input.get_vector("left", "right", "up", "down")
