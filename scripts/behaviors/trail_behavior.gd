extends Behavior
class_name TrailBehavior

@export var trail_length := 25
@export var trail_duration := 1.0

var line: Line2D
var points_array: Array[Vector2] = []
var is_active := false

func start_trail() -> void:
	is_active = true
	line.clear_points()
	points_array.clear()
	get_tree().create_timer(trail_duration).timeout.connect(stop_trail, CONNECT_ONE_SHOT)

func stop_trail() -> void:
	if not is_instance_valid(line): return
	is_active = false
	line.clear_points()
	points_array.clear()

func _ready() -> void:
	line = Line2D.new()
	var width_curve := Curve.new()
	width_curve.add_point(Vector2(0.0, 0.0))
	width_curve.add_point(Vector2(1.0, 1.0))
	line.width_curve = width_curve
	line.width = UnitBase.UNIT_RADIUS / 2.0
	add_child(line)
	line.position.y = -UnitBase.UNIT_RADIUS / 2.0
	belong.on_dash_start.connect(start_trail)

func _exit_tree() -> void:
	belong.on_dash_start.disconnect(start_trail)

func _process(_delta: float) -> void:
	if not is_active: return
	points_array.append(belong.global_position)
	if points_array.size() > trail_length:
		points_array.pop_front()
	line.points = points_array
