extends Node2D
class_name MapGenerate

const MAP_SHADER = preload("uid://bpkag4ftbs2jm")
const TILE_MAP_LAYER = preload("uid://cp5lqpua546if")
const TILE_MAP_SCALE := 0.4

@export var size_w := 20
@export var size_h := 15
@export var rng_seed := 0
@export var shader_color: Color = "#009d00"

var map_size: Vector2
var rng: RandomNumberGenerator

func generate() -> void:
	var map_layer := Node2D.new()
	for i in range(3):
		var layer := TILE_MAP_LAYER.instantiate() as TileMapLayer
		layer.name = ["BG", "Shadow", "Deco"][i]
		layer.use_parent_material = true
		for x in range(size_w):
			for y in range(size_h):
				var atlas_index = rng.rand_weighted(MapGenerateTile.TILES[i][1])
				var atlas_coords = MapGenerateTile.TILES[i][0][atlas_index]
				layer.set_cell(Vector2i(x, y), 0, atlas_coords)
		map_layer.add_child(layer)
		if i == 0:
			map_size = layer.map_to_local(layer.get_used_rect().end) * TILE_MAP_SCALE
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
