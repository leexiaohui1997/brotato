extends TileMapLayer
class_name MapGenerateTile

const BG_TILES = [Vector2i(0, 4), Vector2i(1, 4)]
const BG_WEIGHTS = [1, 0.005]

const SHADOW_TILES = [Vector2i(2, 4), Vector2i(12, 0)]
const SHADOW_WEIGHTS = [0.002, 1]

const DECO_TILES = [Vector2i(3, 4), Vector2i(4, 4), Vector2i(5, 4), Vector2i(12, 0)]
const DECO_WEIGHTS = [0.002, 0.002, 0.002, 1]

const TILES = [
	[BG_TILES, BG_WEIGHTS],
	[SHADOW_TILES, SHADOW_WEIGHTS],
	[DECO_TILES, DECO_WEIGHTS]
]
