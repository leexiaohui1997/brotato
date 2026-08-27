extends Node2D
class_name GameNode

const MAP_GENERATE = preload("uid://b2c6lrpx36ia1")
const UNIT_BASE = preload("uid://c1l18o0sk0hw1")

const CAMERA_ZOOM = 1.5

@export var map_config: MapConfig
@export var player_unit: UnitConfig.HeroUnit

@onready var entities: Node2D = $Entities

var map_node: MapGenerate
var player: UnitBase
var camera: Camera2D

## 生成游戏地图
func generate_map() -> void:
	map_node = MAP_GENERATE.instantiate()
	map_node.name = "Map"
	if map_config:
		map_node.rng_seed = map_config.map_seed
		map_node.size_w = map_config.map_size_w
		map_node.size_h = map_config.map_size_h
		map_node.shader_color = map_config.map_color
	add_child(map_node)

## 生成玩家
func generate_player() -> void:
	var born_pos := map_config.player_born_pos if map_config else Vector2i(
		randi_range(0, map_node.map_size.x),
		randi_range(0, map_node.map_size.y)
	)
	player = UNIT_BASE.instantiate()
	player.name = "Player"
	player.config = UnitConfig.new()
	player.config.type = player_unit as UnitConfig.UnitType
	player.position = born_pos
	entities.add_child(player)
	player.add_behavior(PlayerBehavior.new())

## 生成相机
func generate_camera() -> void:
	camera = Camera2D.new()
	camera.name = "Camera"
	camera.zoom = Vector2.ONE * CAMERA_ZOOM
	camera.position_smoothing_enabled = true
	camera.position_smoothing_speed = 8.0
	camera.limit_top = 0
	camera.limit_left = 0
	camera.limit_right = map_node.map_size.x
	camera.limit_bottom = map_node.map_size.y
	player.add_child(camera)

func _ready() -> void:
	generate_map()
	generate_player()
	generate_camera()
