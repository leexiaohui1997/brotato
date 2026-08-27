class_name Helper

static func some(arr: Array, fn: Callable) -> bool:
	for item in arr:
		if fn.call(item):
			return true
	return false
