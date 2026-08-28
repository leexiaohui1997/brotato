extends Node2D
class_name GameNode

const MAP_GENERATE = preload("uid://b2c6lrpx36ia1")
const UNIT_COMMON = preload("uid://cupf41ydqkiqd")

const CAMERA_ZOOM = 1.5

@export var map_config: MapConfig
@export var player_unit: UnitConfig.HeroUnit

@onready var entities: Node2D = $Entities

var map_node: MapGenerate
var player: UnitCommon
var camera: Camera2D
var enemy_uid := 1

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
	var born_pos := map_config.player_born_pos if map_config else get_born_pos(true)
	player = UNIT_COMMON.instantiate()
	player.name = "Player"
	player.config = UnitConfig.new()
	player.config.type = player_unit as UnitConfig.UnitType
	player.position = born_pos
	entities.add_child(player)
	player.add_behavior(PlayerBehavior.new())
	player.add_behavior(TrailBehavior.new())

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

## 生成敌人
func spawn_enemy() -> void:
	var enemy := UNIT_COMMON.instantiate() as UnitCommon
	enemy.name = "Enemy_%d" % [enemy_uid]
	enemy_uid += 1
	enemy.config = UnitConfig.new()
	enemy.config.type = UnitConfig.EnemyUnit.values().pick_random()
	enemy.position = get_born_pos(false)
	entities.add_child(enemy)
	enemy.add_behavior(EnemyBehavior.new())

## 批量生成敌人
func spawn_enemies(count: int) -> void:
	for i in range(count):
		spawn_enemy()

## 获取初始位置
func get_born_pos(is_player: bool) -> Vector2i:
	var units: Array[UnitCommon] = []
	units.assign(entities.find_children("*", "UnitCommon", false, false))
	for i in range(100):
		var vec := CoordUtils.get_random_pos(map_node.map_start_pos, map_node.map_end_pos, units)
		if is_player:
			return vec
		if abs(vec.distance_to(player.global_position)) <= UnitBase.UNIT_RADIUS * 5:
			continue
		return vec
	return map_node.map_start_pos

func _ready() -> void:
	generate_map()
	generate_player()
	generate_camera()

func _enter_tree() -> void:
	Global.game = self

func _exit_tree() -> void:
	Global.game = null

func _on_spawn_enemy_timer_timeout() -> void:
	spawn_enemies(3)
