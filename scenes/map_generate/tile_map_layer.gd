extends TileMapLayer
class_name MapGenerateTile

var tile_datas: Dictionary[int, Array] = {}
func load_tile_datas():
	if tile_datas.size():
		return tile_datas
	for sidx in tile_set.get_source_count():
		var sid := tile_set.get_source_id(sidx)
		var s := tile_set.get_source(sid)
		tile_datas[sid] = []
		for tidx in s.get_tiles_count():
			var tvec := s.get_tile_id(tidx)
			var t := s.get_tile_data(tvec, 0) as TileData
			tile_datas[sid].append([t, tvec])
	return tile_datas

func get_tiles(terrain: int) -> Array:
	var result: Array = [[], []]
	var data = load_tile_datas()[0]

	# 非背景层叠加空白层
	var ters = [terrain]
	if terrain != 0:
		ters.append(3)

	for item in data:
		var t: TileData = item[0]
		var tvec: Vector2i = item[1]
		if not ters.has(t.terrain):
			continue
		result[0].append(tvec)
		result[1].append(t.probability)
	return result
