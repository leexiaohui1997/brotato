extends Node2D
class_name MapGenerate

const MAP_SHADER = preload("uid://bpkag4ftbs2jm")
const TILE_MAP_LAYER = preload("uid://cp5lqpua546if")
const TILE_SIZE := 50
const TILE_MAP_SCALE := TILE_SIZE / 125.0

@export var size_w := 20
@export var size_h := 15
@export var rng_seed := 0
@export var shader_color: Color = "#009d00"

var map_size: Vector2i
var map_start_pos: Vector2
var map_end_pos: Vector2

var rng: RandomNumberGenerator

func generate() -> void:
	var map_layer := Node2D.new()
	map_layer.name = "MapLayers"
	for i in range(3):
		var layer := TILE_MAP_LAYER.instantiate() as MapGenerateTile
		layer.name = ["BG", "Shadow", "Deco"][i]
		layer.use_parent_material = true
		var tiles = layer.get_tiles(i)
		for x in range(size_w):
			for y in range(size_h):
				var atlas_index = rng.rand_weighted(tiles[1])
				var atlas_coords = tiles[0][atlas_index]
				layer.set_cell(Vector2i(x, y), 0, atlas_coords)
		map_layer.add_child(layer)
		if i == 0:
			map_size = layer.get_used_rect().end * TILE_SIZE
			map_start_pos = Vector2(TILE_SIZE / 2.0, TILE_SIZE)
			map_end_pos = Vector2(float(map_size.x) - map_start_pos.x, float(map_size.y))
	map_layer.material = create_material()
	map_layer.scale = Vector2.ONE * TILE_MAP_SCALE
	add_child(map_layer)

func create_material() -> ShaderMaterial:
	if not shader_color:
		return null
	var mate := ShaderMaterial.new()
	mate.shader = MAP_SHADER
	mate.set_shader_parameter("tint_color", shader_color)
	return mate

func _ready() -> void:
	rng = RandomNumberGenerator.new()
	if rng_seed: rng.seed = rng_seed
	generate()
