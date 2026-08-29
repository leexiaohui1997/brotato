class_name Helper

static func some(arr: Array, fn: Callable) -> bool:
	for item in arr:
		if fn.call(item):
			return true
	return false

static func get_chance(chance: float) -> bool:
	return randf() < chance
