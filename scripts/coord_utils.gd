class_name CoordUtils

static func get_random_pos(start_pos: Vector2, end_pos: Vector2, units: Array[UnitCommon] = [], limit := 100) -> Vector2i:
	var start_x = ceil(start_pos.x)
	var start_y = ceil(start_pos.y)
	var end_x = floor(end_pos.x)
	var end_y = floor(end_pos.y)
	for i in range(limit):
		var x := randi_range(start_x, end_x)
		var y := randi_range(start_y, end_y)
		var vec := Vector2i(x, y)
		if i < limit - 1 and Helper.some(units, func(item: UnitCommon): return abs(item.global_position.distance_to(vec)) <= UnitBase.UNIT_RADIUS):
			continue
		return vec
	return Vector2i(start_x, start_y)
